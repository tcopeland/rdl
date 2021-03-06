class RDL::Wrap
  def self.wrapped?(klass, meth)
    RDL::Util.method_defined?(klass, wrapped_name(klass, meth))
  end

  def self.resolve_alias(klass, meth)
    klass = klass.to_s
    meth = meth.to_sym
    while $__rdl_aliases[klass] && $__rdl_aliases[klass][meth]
      if $__rdl_info.has_any?(klass, meth, [:pre, :post, :type])
        raise RuntimeError, "Alias #{RDL::Util.pp_klass_method(klass, meth)} has contracts. Contracts are only allowed on methods, not aliases."
      end
      meth = $__rdl_aliases[klass][meth]
    end
    return meth
  end

  def self.get_type_params(klass)
    klass = klass.to_s
    $__rdl_type_params[klass]
  end

  # [+klass+] may be a Class, String, or Symbol
  # [+meth+] may be a String or Symbol
  #
  # Wraps klass#method to check contracts and types. Does not rewrap
  # if already wrapped. Also records source location of method.
  def self.wrap(klass_str, meth)
    $__rdl_wrap_switch.off {
      klass_str = klass_str.to_s
      klass = RDL::Util.to_class klass_str
      return if wrapped? klass, meth
      return if RDL::Config.instance.nowrap.member? klass
      raise ArgumentError, "Attempt to wrap #{RDL::Util.pp_klass_method(klass, meth)}" if klass.to_s =~ /^RDL::/
      meth_old = wrapped_name(klass, meth) # meth_old is a symbol
      # return if (klass.method_defined? meth_old) # now checked above by wrapped? call
      is_singleton_method = RDL::Util.has_singleton_marker(klass_str)
      full_method_name = RDL::Util.pp_klass_method(klass_str, meth)
      klass_str_without_singleton = if is_singleton_method then RDL::Util.remove_singleton_marker(klass_str) else klass_str end

      klass.class_eval <<-RUBY, __FILE__, __LINE__
        alias_method meth_old, meth
        def #{meth}(*args, &blk)
          klass = "#{klass_str}"
          meth = types = matches = nil
	        bind = binding
          inst = nil

          $__rdl_wrap_switch.off {
            $__rdl_wrapped_calls["#{full_method_name}"] += 1 if RDL::Config.instance.gather_stats
            inst = nil
            inst = @__rdl_inst if defined? @__rdl_inst
            inst = Hash[$__rdl_type_params[klass][0].zip []] if (not(inst) && $__rdl_type_params[klass])
            inst = {} if not inst
            #{if not(is_singleton_method) then "inst[:self] = RDL::Type::NominalType.new(self.class)" end}
#            puts "Intercepted #{full_method_name}(\#{args.join(", ")}) { \#{blk} }, inst = \#{inst.inspect}"
            meth = RDL::Wrap.resolve_alias(klass, #{meth.inspect})
            RDL::Typecheck.typecheck(klass, meth) if $__rdl_info.get(klass, meth, :typecheck) == :call
            pres = $__rdl_info.get(klass, meth, :pre)
            RDL::Contract::AndContract.check_array(pres, self, *args, &blk) if pres
            types = $__rdl_info.get(klass, meth, :type)
            if types
              matches, args, blk, bind = RDL::Type::MethodType.check_arg_types("#{full_method_name}", self, bind, types, inst, *args, &blk)
            end
          }
	        ret = send(#{meth_old.inspect}, *args, &blk)
          $__rdl_wrap_switch.off {
            posts = $__rdl_info.get(klass, meth, :post)
            RDL::Contract::AndContract.check_array(posts, self, ret, *args, &blk) if posts
            if matches
              ret = RDL::Type::MethodType.check_ret_types(self, "#{full_method_name}", types, inst, matches, ret, bind, *args, &blk)
            end
            if RDL::Config.instance.guess_types.include?("#{klass_str_without_singleton}".to_sym)
              $__rdl_info.add(klass, meth, :otype, { args: (args.map { |arg| arg.class }), ret: ret.class, block: block_given? })
            end
            return ret
          }
        end
        if (public_method_defined? meth_old) then public meth
        elsif (protected_method_defined? meth_old) then protected meth
        elsif (private_method_defined? meth_old) then private meth
        end
RUBY
    }
  end

  # [+default_class+] should be a class
  # [+name+] is the name to give the block as a contract
  def self.process_pre_post_args(default_class, name, *args, &blk)
    klass = slf = meth = contract = nil
    default_class = "Object" if (default_class.is_a? Object) && (default_class.to_s == "main") # special case for main
    if args.size == 3
      klass = class_to_string args[0]
      slf, meth = meth_to_sym args[1]
      contract = args[2]
    elsif args.size == 2 && blk
      klass = class_to_string args[0]
      slf, meth = meth_to_sym args[1]
      contract = RDL::Contract::FlatContract.new(name, &blk)
    elsif args.size == 2
      klass = default_class.to_s
      slf, meth = meth_to_sym args[0]
      contract = args[1]
    elsif args.size == 1 && blk
      klass = default_class.to_s
      slf, meth = meth_to_sym args[0]
      contract = RDL::Contract::FlatContract.new(name, &blk)
    elsif args.size == 1
      klass = default_class.to_s
      contract = args[0]
    elsif blk
      klass = default_class.to_s
      contract = RDL::Contract::FlatContract.new(name, &blk)
    else
      raise ArgumentError, "Invalid arguments"
    end
    raise ArgumentError, "#{contract.class} received where Contract expected" unless contract.class < RDL::Contract::Contract
#    meth = :initialize if meth && meth.to_sym == :new  # actually wrap constructor
    klass = RDL::Util.add_singleton_marker(klass) if slf # && (meth != :initialize)
    return [klass, meth, contract]
  end

  # [+default_class+] should be a class
  def self.process_type_args(default_class, *args, &blk)
    klass = meth = type = nil
    default_class = "Object" if (default_class.is_a? Object) && (default_class.to_s == "main") # special case for main
    if args.size == 3
      klass = class_to_string args[0]
      slf, meth = meth_to_sym args[1]
      type = type_to_type args[2]
    elsif args.size == 2
      klass = default_class.to_s
      slf, meth = meth_to_sym args[0]
      type = type_to_type args[1]
    elsif args.size == 1
      klass = default_class.to_s
      type = type_to_type args[0]
    else
      raise ArgumentError, "Invalid arguments"
    end
    raise ArgumentError, "Excepting method type, got #{type.class} instead" if type.class != RDL::Type::MethodType
#    meth = :initialize if meth && slf && meth.to_sym == :new  # actually wrap constructor
    klass = RDL::Util.add_singleton_marker(klass) if slf
    return [klass, meth, type]
  end

  private

  def self.wrapped_name(klass, meth)
    "__rdl_#{meth.to_s}_old".to_sym
  end

  def self.class_to_string(klass)
    case klass
    when Class
      return klass.to_s
    when String
      return klass
    when Symbol
      return klass.to_s
    else
      raise ArgumentError, "#{klass.class} received where klass (Class, Symbol, or String) expected"
    end
  end

  def self.meth_to_sym(meth)
    raise ArgumentError, "#{meth.class} received where method (Symbol or String) expected" unless meth.class == String || meth.class == Symbol
    meth = meth.to_s
    meth =~ /^(.*\.)?(.*)$/
    raise RuntimeError, "Only self.method allowed" if $1 && $1 != "self."
    return [$1, $2.to_sym]
  end

  def self.type_to_type(type)
    case type
    when RDL::Type::Type
      return type
    when String
      return $__rdl_parser.scan_str type
    end
  end

  # called by Object#method_added (sing=false) and Object#singleton_method_added (sing=true)
  def self.do_method_added(the_self, sing, klass, meth)
    # Apply any deferred contracts and reset list
    if sing
      loc = the_self.singleton_method(meth).source_location
    else
      loc = the_self.instance_method(meth).source_location
    end

    if $__rdl_deferred.size > 0
      $__rdl_info.set(klass, meth, :source_location, loc)
      a = $__rdl_deferred
      $__rdl_deferred = [] # Reset before doing more work to avoid infinite recursion
      a.each { |prev_klass, kind, contract, h|
        if RDL::Util.has_singleton_marker(klass)
          tmp_klass = RDL::Util.remove_singleton_marker(klass)
        else
          tmp_klass = klass
        end
        raise RuntimeError, "Deferred contract from class #{prev_klass} being applied in class #{tmp_klass}" if prev_klass != tmp_klass
        $__rdl_info.add(klass, meth, kind, contract)
        RDL::Wrap.wrap(klass, meth) if h[:wrap]
        unless $__rdl_info.set(klass, meth, :typecheck, h[:typecheck])
          raise RuntimeError, "Inconsistent typecheck flag on #{RDL::Util.pp_klass_method(klass, meth)}"
        end
        RDL::Typecheck.typecheck(klass, meth) if h[:typecheck] == :now
        if (h[:typecheck] && h[:typecheck] != :call)
          $__rdl_to_typecheck[h[:typecheck]] = Set.new unless $__rdl_to_typecheck[h[:typecheck]]
          $__rdl_to_typecheck[h[:typecheck]].add([klass, meth])
        end
      }
    end

    # Wrap method if there was a prior contract for it.
    if $__rdl_to_wrap.member? [klass, meth]
      $__rdl_to_wrap.delete [klass, meth]
      RDL::Wrap.wrap(klass, meth)
      $__rdl_info.set(klass, meth, :source_location, loc)
    end

    # Type check method if requested
    if $__rdl_to_typecheck[:now].member? [klass, meth]
      $__rdl_to_typecheck[:now].delete [klass, meth]
      RDL::Typecheck.typecheck(klass, meth)
    end

    if RDL::Config.instance.guess_types.include?(the_self.to_s.to_sym) && !$__rdl_info.has?(klass, meth, :type)
      # Added a method with no type annotation from a class we want to guess types for
      RDL::Wrap.wrap(klass, meth)
    end
  end
end

class Object

  # [+klass+] may be Class, Symbol, or String
  # [+method+] may be Symbol or String
  # [+contract+] must be a Contract
  # [+wrap+] indicates whether the contract should be enforced (true) or just recorded (false)
  #
  # Add a precondition to a method. Possible invocations:
  # pre(klass, meth, contract)
  # pre(klass, meth) { block } = pre(klass, meth, FlatContract.new { block })
  # pre(meth, contract) = pre(self, meth, contract)
  # pre(meth) { block } = pre(self, meth, FlatContract.new { block })
  # pre(contract) = pre(self, next method, contract)
  # pre { block } = pre(self, next method, FlatContract.new { block })
  def pre(*args, wrap: RDL::Config.instance.pre_defaults[:wrap], &blk)
    $__rdl_contract_switch.off { # Don't check contracts inside RDL code itself
      klass, meth, contract = RDL::Wrap.process_pre_post_args(self, "Precondition", *args, &blk)
      if meth
        $__rdl_info.add(klass, meth, :pre, contract)
        if wrap
          if RDL::Util.method_defined?(klass, meth) || meth == :initialize # there is always an initialize
            RDL::Wrap.wrap(klass, meth)
          else
            $__rdl_to_wrap << [klass, meth]
          end
        end
      else
        $__rdl_deferred << [klass, :pre, contract, {wrap: wrap}]
      end
      nil
    }
  end

  # Add a postcondition to a method. Same possible invocations as pre.
  def post(*args, wrap: RDL::Config.instance.post_defaults[:wrap], &blk)
    $__rdl_contract_switch.off {
      klass, meth, contract = RDL::Wrap.process_pre_post_args(self, "Postcondition", *args, &blk)
      if meth
        $__rdl_info.add(klass, meth, :post, contract)
        if wrap
          if RDL::Util.method_defined?(klass, meth) || meth == :initialize
            RDL::Wrap.wrap(klass, meth)
          else
            $__rdl_to_wrap << [klass, meth]
          end
        end
      else
        $__rdl_deferred << [klass, :post, contract, {wrap: wrap}]
      end
      nil
    }
  end

  # [+ klass +] may be Class, Symbol, or String
  # [+ method +] may be Symbol or String
  # [+ type +] may be Type or String
  # [+ wrap +] indicates whether the type should be enforced (true) or just recorded (false)
  # [+ typecheck +] indicates a method that should be statically type checked, as follows
  #    if :call, indicates method should be typechecked when called
  #    if :now, indicates method should be typechecked immediately
  #    if other-symbol, indicates method should be typechecked when rdl_do_typecheck(other-symbol) is called
  #
  # Set a method's type. Possible invocations:
  # type(klass, meth, type)
  # type(meth, type)
  # type(type)
  def type(*args, wrap: RDL::Config.instance.type_defaults[:wrap], typecheck: RDL::Config.instance.type_defaults[:typecheck], &blk)
    $__rdl_contract_switch.off {
      klass, meth, type = begin
                            RDL::Wrap.process_type_args(self, *args, &blk)
                          rescue Racc::ParseError => err
                            # Remove enough backtrace to only include actual source line
                            # Warning: Adjust the -5 below if the code (or this comment) changes
                            bt = err.backtrace
                            bt.shift until bt[0] =~ /^#{__FILE__}:#{__LINE__-5}/
                            bt.shift # remove $__rdl_contract_switch.off call
                            bt.shift # remove type call itself
                            err.set_backtrace bt
                            raise err
                          end
      if meth
# It turns out Ruby core/stdlib don't always follow this convention...
#        if (meth.to_s[-1] == "?") && (type.ret != $__rdl_type_bool)
#          warn "#{RDL::Util.pp_klass_method(klass, meth)}: methods that end in ? should have return type %bool"
#        end
        $__rdl_info.add(klass, meth, :type, type)
        unless $__rdl_info.set(klass, meth, :typecheck, typecheck)
          raise RuntimeError, "Inconsistent typecheck flag on #{RDL::Util.pp_klass_method(klass, meth)}"
        end
        if wrap
          if RDL::Util.method_defined?(klass, meth) || meth == :initialize
            $__rdl_info.set(klass, meth, :source_location, RDL::Util.to_class(klass).instance_method(meth).source_location)
            RDL::Typecheck.typecheck(klass, meth) if typecheck == :now
            RDL::Wrap.wrap(klass, meth)
          else
            $__rdl_to_wrap << [klass, meth]
            if (typecheck && typecheck != :call)
              $__rdl_to_typecheck[typecheck] = Set.new unless $__rdl_to_typecheck[typecheck]
              $__rdl_to_typecheck[typecheck].add([klass, meth])
            end
          end
        end
      else
        $__rdl_deferred << [klass, :type, type, {wrap: wrap,
                                                 typecheck: typecheck}]
      end
      nil
    }
  end

  # [+ klass +] is the class containing the variable; self if omitted; ignored for local and global variables
  # [+ var +] is a symbol or string containing the name of the variable
  # [+ typ +] is a string containing the type
  def var_type(klass=self, var, typ)
    raise RuntimeError, "Variable cannot begin with capital" if var.to_s =~ /^[A-Z]/
    return if var.to_s =~ /^[a-z]/ # local variables handled specially, inside type checker
    raise RuntimeError, "Global variables can't be typed in a class" unless klass = self
    klass = RDL::Util::GLOBAL_NAME if var.to_s =~ /^\$/
    unless $__rdl_info.set(klass, var, :type, $__rdl_parser.scan_str("#T #{typ}"))
      raise RuntimeError, "Type already declared for #{var}"
    end
    nil
  end

  # In the following three methods
  # [+ args +] is a sequence of symbol, typ. attr_reader is called for each symbol,
  # and var_type is called to assign the immediately following type to the
  # attribute named after that symbol.
  def attr_accessor_type(*args)
    args.each_slice(2) { |name, typ|
      attr_accessor name
      var_type ("@" + name.to_s), typ
      type name, "() -> #{typ}"
      type name.to_s + "=", "(#{typ}) -> #{typ}"
    }
    nil
  end

  def attr_reader_type(*args)
    args.each_slice(2) { |name, typ|
      attr_reader name
      var_type ("@" + name.to_s), typ
      type name, "() -> #{typ}"
    }
    nil
  end

  alias_method :attr_type, :attr_reader_type

  def attr_writer_type(*args)
    args.each_slice(2) { |name, typ|
      attr_writer name
      var_type ("@" + name.to_s), typ
      type name.to_s + "=", "(#{typ}) -> #{typ}"
    }
    nil
  end


  def self.method_added(meth)
    $__rdl_contract_switch.off {
      klass = self.to_s
      klass = "Object" if (klass.is_a? Object) && (klass.to_s == "main")
      RDL::Wrap.do_method_added(self, false, klass, meth)
      nil
    }
  end

  def self.singleton_method_added(meth)
    $__rdl_contract_switch.off {
      klass = self.to_s
      klass = "Object" if (klass.is_a? Object) && (klass.to_s == "main")
      sklass = RDL::Util.add_singleton_marker(klass)
      RDL::Wrap.do_method_added(self, true, sklass, meth)
      nil
    }
  end

  # Aliases contracts for meth_old and meth_new. Currently, this must
  # be called for any aliases or they will not be wrapped with
  # contracts. Only creates aliases in the current class.
  def rdl_alias(new_name, old_name)
    $__rdl_contract_switch.off {
      klass = self.to_s
      klass = "Object" if (klass.is_a? Object) && (klass.to_s == "main")
      $__rdl_aliases[klass] = {} unless $__rdl_aliases[klass]
      if $__rdl_aliases[klass][new_name]
        raise RuntimeError,
              "Tried to alias #{new_name}, already aliased to #{$__rdl_aliases[klass][new_name]}"
      end
      $__rdl_aliases[klass][new_name] = old_name

      if self.method_defined? new_name
        RDL::Wrap.wrap(klass, new_name)
      else
        $__rdl_to_wrap << [klass, old_name]
      end
      nil
    }
  end

  # [+params+] is an array of symbols or strings that are the
  # parameters of this (generic) type
  # [+variance+] is an array of the corresponding variances, :+ for
  # covariant, :- for contravariant, and :~ for invariant. If omitted,
  # all parameters are assumed to be invariant
  # [+all+] should be a symbol naming an all? method that behaves like Array#all?, and that accepts
  # a block that takes arguments in the same order as the type parameters
  # [+blk+] is for advanced use only. If present, [+all+] must be
  # nil. Whenever an instance of this class is instantiated!, the
  # block will be passed an array typs corresponding to the type
  # parameters of the class, and the block should return true if and
  # only if self is a member of self.class<typs>.
  def type_params(params, all, variance: nil, &blk)
    $__rdl_contract_switch.off {
      raise RuntimeError, "Empty type parameters not allowed" if params.empty?
      klass = self.to_s
      klass = "Object" if (klass.is_a? Object) && (klass.to_s == "main")
      if $__rdl_type_params[klass]
        raise RuntimeError, "#{klass} already has type parameters #{$__rdl_type_params[klass]}"
      end
      params = params.map { |v|
        raise RuntimeError, "Type parameter #{v.inspect} is not symbol or string" unless v.class == String || v.class == Symbol
        v.to_sym
      }
      raise RuntimeError, "Duplicate type parameters not allowed" unless params.uniq.size == params.size
      raise RuntimeError, "Expecting #{params.size} variance annotations, got #{variance.size}" if variance && params.size != variance.size
      raise RuntimeError, "Only :+, +-, and :~ are allowed variance annotations" unless (not variance) || variance.all? { |v| [:+, :-, :~].member? v }
      raise RuntimeError, "Can't pass both all and a block" if all && blk
      raise RuntimeError, "all must be a symbol" unless (not all) || (all.instance_of? Symbol)
      chk = all || blk
      raise RuntimeError, "At least one of {all, blk} required" unless chk
      variance = params.map { |p| :~ } unless variance # default to invariant
      $__rdl_type_params[klass] = [params, variance, chk]
      nil
    }
  end

  def rdl_nowrap
    $__rdl_contract_switch.off {
      RDL.config { |config| config.add_nowrap(self, self.singleton_class) }
      nil
    }
  end

  # [+typs+] is an array of types, classes, symbols, or strings to instantiate
  # the type parameters. If a class, symbol, or string is given, it is
  # converted to a NominalType.
  def instantiate!(*typs)
    $__rdl_contract_switch.off {
      klass = self.class.to_s
      klass = "Object" if (klass.is_a? Object) && (klass.to_s == "main")
      formals, _, all = $__rdl_type_params[klass]
      raise RuntimeError, "Receiver is of class #{klass}, which is not parameterized" unless formals
      raise RuntimeError, "Expecting #{params.size} type parameters, got #{typs.size}" unless formals.size == typs.size
      raise RuntimeError, "Instance already has type instantiation" if (defined? @__rdl_type) && @rdl_type
      new_typs = typs.map { |t| if t.is_a? RDL::Type::Type then t else $__rdl_parser.scan_str "#T #{t}" end }
      t = RDL::Type::GenericType.new(RDL::Type::NominalType.new(klass), *new_typs)
      if all.instance_of? Symbol
        self.send(all) { |*objs|
          new_typs.zip(objs).each { |nt, obj|
            if nt.instance_of? RDL::Type::GenericType # require obj to be instantiated
              t_obj = RDL::Util.rdl_type(obj)
              raise RDL::Type::TypeError, "Expecting element of type #{nt.to_s}, but got uninstantiated object #{obj.inspect}" unless t_obj
              raise RDL::Type::TypeError, "Expecting type #{nt.to_s}, got type #{t_obj.to_s}" unless t_obj <= nt
            else
              raise RDL::Type::TypeError, "Expecting type #{nt.to_s}, got #{obj.inspect}" unless nt.member? obj
            end
          }
        }
      else
        raise RDL::Type::TypeError, "Not an instance of #{t}" unless instance_exec(*new_typs, &all)
      end
      @__rdl_type = t
      self
    }
  end

  def deinstantiate!
    $__rdl_contract_switch.off {
      raise RuntimeError, "Class #{self.to_s} is not parameterized" unless $__rdl_type_params[klass]
      raise RuntimeError, "Instance is not instantiated" unless @__rdl_type && @@__rdl_type.instance_of?(RDL::Type::GenericType)
      @__rdl_type = nil
      self
    }
  end

  # Returns a new object that wraps self in a type cast. If force is true this cast is *unchecked*, so use with caution
  def type_cast(typ, force: false)
    $__rdl_contract_switch.off {
      new_typ = if typ.is_a? RDL::Type::Type then typ else $__rdl_parser.scan_str "#T #{typ}" end
      raise RuntimeError, "type cast error: self not a member of #{new_typ}" unless force || typ.member?(self)
      obj = SimpleDelegator.new(self)
      obj.instance_variable_set('@__rdl_type', new_typ)
      obj
    }
  end

  # Add a new type alias.
  # [+name+] must be a string beginning with %.
  # [+typ+] can be either a string, in which case it will be parsed
  # into a type, or a Type.
  def type_alias(name, typ)
    $__rdl_contract_switch.off {
      raise RuntimeError, "Attempt to redefine type #{name}" if $__rdl_special_types[name]
      case typ
      when String
        t = $__rdl_parser.scan_str "#T #{typ}"
        $__rdl_special_types[name] = t
      when RDL::Type::Type
        $__rdl_special_types[name] = typ
      else
        raise RuntimeError, "Unexpected typ argument #{typ.inspect}"
      end
      nil
    }
  end

  # Type check all methods that had annotation `typecheck: sym' at type call
  def rdl_do_typecheck(sym)
    $__rdl_to_typecheck[sym].each { |klass, meth|
      RDL::Typecheck.typecheck(klass, meth)
    }
    $__rdl_to_typecheck[sym] = Array.new
    nil
  end

  # Does nothing at run time
  def rdl_note_type(x)
    return x
  end

end
