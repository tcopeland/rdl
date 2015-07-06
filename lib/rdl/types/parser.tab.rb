#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.12
# from Racc grammer file "".
#

require 'racc/parser.rb'


require_relative 'lexer.rex'

module RDL::Type

class Parser < Racc::Parser

module_eval(<<'...end parser.racc/module_eval...', 'parser.racc', 103)

def initialize()
  @ttrue = RDL::Type::NominalType.new(TrueClass)
  @tfalse = RDL::Type::NominalType.new(FalseClass)
  @tbool = RDL::Type::UnionType.new(@ttrue, @tfalse)
  @yydebug = true
end

...end parser.racc/module_eval...
##### State transition tables begin ###

racc_action_table = [
    15,    50,    12,    11,    13,    31,     9,     4,    43,    37,
    14,    38,    20,    21,    26,     5,    40,    15,    26,    19,
    11,    13,    15,     9,    19,    11,    13,    14,     9,    20,
    21,    29,    14,    26,    20,    21,    15,    30,    12,    11,
    13,    15,     9,    12,    11,    13,    14,     9,    25,    45,
    15,    14,    12,    11,    13,    15,     9,    12,    11,    13,
    14,     9,     5,    23,    15,    14,    48,    11,    13,    15,
     9,    12,    11,    13,    14,     9,    49,     6,    15,    14,
    12,    11,    13,    15,     9,    12,    11,    13,    14,     9,
    34,   nil,    15,    14,    12,    11,    13,    15,     9,    12,
    11,    13,    14,   nil,   nil,   nil,   nil,    14 ]

racc_action_check = [
    31,    48,    31,    31,    31,    19,    31,     0,    36,    27,
    31,    28,    31,    31,    48,     0,    29,     5,    19,     5,
     5,     5,    30,     5,    30,    30,    30,     5,    30,     5,
     5,    16,    30,    12,    30,    30,    50,    17,    50,    50,
    50,    37,    50,    37,    37,    37,    50,    37,    10,    39,
     9,    37,     9,     9,     9,    14,     9,    14,    14,    14,
     9,    14,    40,     6,    45,    14,    45,    45,    45,    26,
    45,    26,    26,    26,    45,    26,    46,     1,     4,    26,
     4,     4,     4,    20,     4,    20,    20,    20,     4,    20,
    24,   nil,    21,    20,    21,    21,    21,    25,    21,    25,
    25,    25,    21,   nil,   nil,   nil,   nil,    25 ]

racc_action_pointer = [
     2,    77,   nil,   nil,    71,    10,    63,   nil,   nil,    43,
    44,   nil,    12,   nil,    48,   nil,    17,    35,   nil,    -3,
    76,    85,   nil,   nil,    76,    90,    62,     7,    -7,     1,
    15,    -7,   nil,   nil,   nil,   nil,   -14,    34,   nil,    46,
    49,   nil,   nil,   nil,   nil,    57,    60,   nil,    -7,   nil,
    29,   nil ]

racc_action_default = [
   -28,   -28,    -1,    -2,   -28,    -6,   -28,    -3,   -16,   -28,
   -20,   -22,   -23,   -24,   -28,   -27,   -28,    -7,    -9,   -23,
   -28,   -28,   -13,    52,   -28,   -28,   -28,   -18,   -28,   -14,
    -6,   -28,   -11,   -12,   -17,   -21,   -28,   -28,   -26,   -28,
   -28,    -8,   -10,   -25,   -19,   -28,   -28,    -4,   -23,   -15,
   -28,    -5 ]

racc_goto_table = [
     7,    16,     2,     3,    39,    24,    28,    42,    35,     1,
    27,   nil,   nil,   nil,   nil,   nil,    32,    33,    36,   nil,
   nil,   nil,    27,   nil,   nil,   nil,    41,   nil,   nil,    44,
   nil,   nil,   nil,    27,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    47,    46,   nil,   nil,   nil,    51 ]

racc_goto_check = [
     4,     5,     2,     3,     6,     4,    10,     8,     9,     1,
     4,   nil,   nil,   nil,   nil,   nil,     4,     4,    10,   nil,
   nil,   nil,     4,   nil,   nil,   nil,     5,   nil,   nil,    10,
   nil,   nil,   nil,     4,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     4,     2,   nil,   nil,   nil,     4 ]

racc_goto_pointer = [
   nil,     9,     2,     3,    -4,    -4,   -25,   nil,   -24,   -17,
    -8,   nil ]

racc_goto_default = [
   nil,   nil,   nil,   nil,    22,   nil,   nil,    17,    18,     8,
   nil,    10 ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 25, :_reduce_1,
  1, 25, :_reduce_2,
  2, 27, :_reduce_3,
  6, 26, :_reduce_4,
  8, 26, :_reduce_5,
  0, 29, :_reduce_6,
  1, 29, :_reduce_7,
  3, 29, :_reduce_8,
  1, 31, :_reduce_9,
  3, 31, :_reduce_10,
  2, 32, :_reduce_11,
  2, 32, :_reduce_12,
  1, 32, :_reduce_13,
  0, 30, :_reduce_14,
  3, 30, :_reduce_15,
  1, 28, :_reduce_16,
  3, 28, :_reduce_17,
  1, 34, :_reduce_18,
  3, 34, :_reduce_19,
  1, 33, :_reduce_20,
  3, 33, :_reduce_21,
  1, 35, :_reduce_22,
  1, 35, :_reduce_23,
  1, 35, :_reduce_24,
  4, 35, :_reduce_25,
  3, 35, :_reduce_26,
  1, 35, :_reduce_27 ]

racc_reduce_n = 28

racc_shift_n = 52

racc_token_table = {
  false => 0,
  :error => 1,
  :COMMA => 2,
  :RARROW => 3,
  :OR => 4,
  :DOUBLE_HASH => 5,
  :ASSOC => 6,
  :FIXNUM => 7,
  :COLON => 8,
  :ID => 9,
  :SYMBOL => 10,
  :SPECIAL_ID => 11,
  :STRING => 12,
  :LPAREN => 13,
  :RPAREN => 14,
  :LBRACE => 15,
  :RBRACE => 16,
  :LBRACKET => 17,
  :RBRACKET => 18,
  :QUERY => 19,
  :STAR => 20,
  :LESS => 21,
  :GREATER => 22,
  :EOF => 23 }

racc_nt_base = 24

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "COMMA",
  "RARROW",
  "OR",
  "DOUBLE_HASH",
  "ASSOC",
  "FIXNUM",
  "COLON",
  "ID",
  "SYMBOL",
  "SPECIAL_ID",
  "STRING",
  "LPAREN",
  "RPAREN",
  "LBRACE",
  "RBRACE",
  "LBRACKET",
  "RBRACKET",
  "QUERY",
  "STAR",
  "LESS",
  "GREATER",
  "EOF",
  "$start",
  "entry",
  "method_type",
  "bare_type",
  "type_expr",
  "arg_list",
  "block",
  "arg",
  "base_arg",
  "union_type",
  "type_expr_comma_list",
  "single_type" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'parser.racc', 18)
  def _reduce_1(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 19)
  def _reduce_2(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 23)
  def _reduce_3(val, _values, result)
            result = val[1]
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 28)
  def _reduce_4(val, _values, result)
            result = RDL::Type::MethodType.new val[1], val[3], val[5]
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 31)
  def _reduce_5(val, _values, result)
            result = RDL::Type::MethodType.new val[1], val[3], RDL::Type::NamedArgType.new(val[5], val[7])
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 36)
  def _reduce_6(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 37)
  def _reduce_7(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 38)
  def _reduce_8(val, _values, result)
     if val[2] then result = val[2].unshift val[0] else val[0] end 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 40)
  def _reduce_9(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 41)
  def _reduce_10(val, _values, result)
     result = RDL::Type::NamedArgType.new(val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 44)
  def _reduce_11(val, _values, result)
     result = RDL::Type::OptionalType.new val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 45)
  def _reduce_12(val, _values, result)
     result = RDL::Type::VarargType.new val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 46)
  def _reduce_13(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 49)
  def _reduce_14(val, _values, result)
     result = nil 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 50)
  def _reduce_15(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 53)
  def _reduce_16(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 54)
  def _reduce_17(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 57)
  def _reduce_18(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 59)
  def _reduce_19(val, _values, result)
            result = [val[0]] + val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 62)
  def _reduce_20(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 63)
  def _reduce_21(val, _values, result)
     result = RDL::Type::UnionType.new val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 66)
  def _reduce_22(val, _values, result)
     result = RDL::Type::SingletonType.new(val[0].to_sym) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 68)
  def _reduce_23(val, _values, result)
          if val[0] == 'nil' then
        result = RDL::Type::NilType.new
      elsif val[0] =~ /^[a-z_]+\w*\'?/ then
        result = RDL::Type::VarType.new(val[0].to_sym)
      else
        result = RDL::Type::NominalType.new val[0]
      end
    
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 77)
  def _reduce_24(val, _values, result)
          if val[0] == '%any' then
        result = RDL::Type::TopType.new
      elsif val[0] == '%bool' then
        result = @tbool
      else
        fail "Unexpected special type identifier #{val[0]}"
      end
    
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 86)
  def _reduce_25(val, _values, result)
          n = RDL::Type::NominalType.new(val[0])
      result = RDL::Type::GenericType.new(n, *val[2])
    
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 90)
  def _reduce_26(val, _values, result)
          result = RDL::Type::TupleType.new(*val[1])
    
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 92)
  def _reduce_27(val, _values, result)
     result = RDL::Type::SingletonType.new(val[0].to_i) 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Parser


end
