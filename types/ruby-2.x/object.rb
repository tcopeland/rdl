class Object
  rdl_nowrap

  # type :ARGF, ARGF
  # type :ARGV, 'Array<String>'
  # type :DATA, 'File'
  # type :ENV, ENV
  # type :FALSE, '%false'
  # type :NIL, 'nil'
  # type :RUBY_COPYRIGHT, 'String'
  # type :RUBY_DESCRIPTION, 'String'
  # type :RUBY_ENGINE, 'String'
  # type :RUBY_PATCHLEVEL, Fixnum
  # type :RUBY_PLATFORM, 'String'
  # type :RUBY_RELEASE_DATE, 'String'
  # type :RUBY_REVISION, Fixnum
  # type :RUBY_VERSION, 'String'
  # type :STDERR, 'IO'
  # type :STDIN, 'IO'
  # type :STDOUT, 'IO'
  # type :TOPLEVEL_BINDING, 'Binding'
  # type :TRUE, '%true'

  type :!~, '(%any other) -> %bool'
  type :<=>, '(%any other) -> Fixnum or nil'
  type :===, '(%any other) -> %bool'
  type :=~, '(%any other) -> nil'
  type :class, '() -> Class'
  type :clone, '() -> self'
#  type :define_singleton_method, '(XXXX : *XXXX)') # TODO
  type :display, '(IO port) -> nil'
  type :dup, '() -> self an_object'
  type :enum_for, '(?Symbol method, *%any args) -> Enumerator<%any>'
  type :enum_for, '(?Symbol method, *%any args) { (*%any args) -> %any } -> Enumerator<%any>'
  type :eql?, '(%any other) -> %bool'
#  type :extend, '(XXXX : *XXXX)') # TODO
  type :freeze, '() -> self'
  type :frozen?, '() -> %bool'
  type :hash, '() -> Fixnum'
  type :inspect, '() -> String'
  type :instance_of?, '(Class) -> %bool'
  type :instance_variable_defined?, '(Symbol or String) -> %bool'
  type :instance_variable_get, '(Symbol or String) -> %any'
  type :instance_variable_set, '(Symbol or String, %any) -> %any' # returns 2nd argument
  type :instance_variables, '() -> Array<Symbol>'
  type :is_a?, '(Class or Module) -> %bool'
  type :kind_of?, '(Class) -> %bool'
  type :method, '(Symbol) -> Method'
  type :methods, '(?%bool regular) -> Array<Symbol>'
  type :nil?, '() -> %bool'
  type :private_methods, '(?%bool all) -> Array<Symbol>'
  type :protected_methods, '(?%bool all) -> Array<Symbol>'
  type :public_method, '(Symbol) -> Method'
  type :public_methods, '(?%bool all) -> Array<Symbol>'
  type :public_send, '(Symbol or String, *%any args) -> %any'
  type :remove_instance_variable, '(Symbol) -> %any'
#  type :respond_to?, '(Symbol or String, ?%bool include_all) -> %bool'
  type :send, '(Symbol or String, *%any args) -> %any', wrap: false # Can't wrap this, used outside wrap switch
  type :singleton_class, '() -> Class'
  type :singleton_method, '(Symbol) -> Method'
  type :singleton_methods, '(?%bool all) -> Array<Symbol>'
  type :taint, '() -> self'
  type :tainted?, '() -> %bool'
#  type :tap, '()') # TODO
  type :to_enum, '(?Symbol method, *%any args) -> Enumerator<%any>'
  type :to_enum, '(?Symbol method, *%any args) {(*%any args) -> %any} -> Enumerator<%any>'
# TODO: above alias for enum_for?
  type :to_s, '() -> String'
  type :trust, '() -> self'
  type :untaint, '() -> self'
  type :untrust, '() -> self'
  type :untrusted?, '() -> %bool'
end
