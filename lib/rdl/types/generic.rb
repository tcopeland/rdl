require_relative 'type'

module RDL::Type
  # A type that is parameterized on one or more other types. The base type
  # must be a NominalType, while the parameters should be strings or symbols
  class GenericType < Type
    attr_reader :base
    attr_reader :params

    def initialize(base, *params)
      raise RuntimeError, "Attempt to create generic type with non-type param" unless params.all? { |p| p.is_a? Type }
      raise "base must be NominalType" unless base.instance_of? NominalType
      @base = base
      @params = params
      super()
    end

    def to_s
      "#{@base}<#{@params.map { |t| t.to_s }.join(', ')}>"
    end

    def ==(other) # :nodoc:
      return false if other.nil?
      other = other.canonical
      return (other.instance_of? GenericType) && (other.base == @base) && (other.params == @params)
    end

    alias eql? ==

    def match(other)
      other = other.canonical
      other = other.type if other.instance_of? AnnotatedArgType
      return true if other.instance_of? WildQuery
      return @params.length == other.params.length && @params.zip(other.params).all? { |t,o| t.match(o) }
    end

    def <=(other)
      other = other.type if other.is_a? DependentArgType
      other = other.canonical
      formals, variance, _ = $__rdl_type_params[base.name]
      # do check here to avoid hiding errors if generic type written
      # with wrong number of parameters but never checked against
      # instantiated instances
      raise TypeError, "No type parameters defined for #{base.name}" unless formals
      return true if other.instance_of? TopType
#      return (@base <= other) if other.instance_of?(NominalType) # raw subtyping not allowed
      if other.instance_of? GenericType
        return false unless @base == other.base
        return variance.zip(params, other.params).all? { |v, self_t, other_t|
          case v
          when :+
            self_t <= other_t
          when :-
            other_t <= self_t
          when :~
            self_t == other_t
          else
            raise RuntimeError, "Unexpected variance #{v}" # shouldn't happen
          end
        }
      end
      if other.instance_of? StructuralType
        # similar logic in NominalType
        inst = Hash[*formals.zip(params).flatten]
        k = base.klass
        other.methods.each_pair { |m, t|
          return false unless k.method_defined? m
          types = $__rdl_info.get(k, m, :type)
          if types
            return false unless types.all? { |t_self| t_self.instantiate(inst) <= t }
          end
        }
        return true
      end
      return false
    end

    def member?(obj, *args)
      raise "No type parameters defined for #{base.name}" unless $__rdl_type_params[base.name]
#      formals = $__rdl_type_params[base.name][0]
      t = RDL::Util.rdl_type obj
      return t <= self if t
      return false unless base.member?(obj, *args)
      return true
    end

    def instantiate(inst)
      GenericType.new(base, *params.map { |t| t.instantiate(inst) })
    end

    def hash
      (61 + @base.hash) * @params.hash
    end

    def to_inst
      return $__rdl_type_params[base.name][0].zip(@params).to_h
    end
  end
end
