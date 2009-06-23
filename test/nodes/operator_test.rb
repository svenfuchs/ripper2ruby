require File.dirname(__FILE__) + '/../test_helper'

class OperatorTest < Test::Unit::TestCase
  include TestHelper
  
  def assert_operator(expr, src, options)
    row    = options[:row]    || 0
    column = options[:column] || 0
    length = options[:length] || src.length

    assert expr.root.is_a?(Ruby::Program)
    assert_equal src, expr.to_ruby
    assert_equal src, expr.src
    assert_equal row, expr.row
    assert_equal column, expr.column
    assert_equal length, expr.length
  end
  
  def assert_unary_operator(operator, options = {})
    src = options[:src] || "#{operator}1"
    expr = build(src).first
    
    assert_equal Ruby::Unary, expr.class
    assert_equal operator.to_s, expr.operator.token
    assert_equal options[:value] || 1, expr.operand.value
    
    assert_operator(expr, src, options)
  end

  def assert_binary_operator(operator, options = {})
    src = options[:src] || "1 #{operator} 2"
    expr = build(src).first

    assert_equal Ruby::Binary, expr.class
    assert_equal operator.to_s, expr.operator.token
    assert_equal options[:left]  || 1, expr.left.value
    assert_equal options[:right] || 2, expr.right.value
    
    assert_operator(expr, src, options)
  end
  
  # UNARY
  
  define_method :'test operator: +1 (+)' do
    assert_unary_operator(:!)
  end
  
  define_method :'test operator: -1 (-)' do
    assert_unary_operator(:!)
  end
  
  define_method :'test operator: !1 (!)' do
    assert_unary_operator(:!)
  end
  
  define_method :'test operator: not 1 (not)' do
    assert_unary_operator(:not, :src => 'not 1')
  end
  
  define_method :'test operator: ~1 (complement/bitwise-not)' do
    assert_unary_operator(:~)
  end
  
  define_method :'test operator: (!1) (complement/bitwise-not, parentheses)' do
    src = '(!1)'
    assert_equal src, build(src).to_ruby
  end
  
  # BINARY
  
  # arithmetical
  
  define_method :'test operator: 1 + 2 (plus)' do
    assert_binary_operator :'+'
  end
  
  define_method :'test operator: 1 - 2 (minus)' do
    assert_binary_operator :'-'
  end
  
  define_method :'test operator: 1 * 2 (times)' do
    assert_binary_operator :'*'
  end
  
  define_method :'test operator: 1 / 2 (over)' do
    assert_binary_operator :'/'
  end
  
  define_method :'test operator: 1 ** 2 (exponentiation)' do
    assert_binary_operator :'**'
  end
  
  define_method :'test operator: 1 % 2 (% / modulo)' do
    assert_binary_operator :'%'
  end
  
  define_method :'test operator: (1 + 2) (plus, parentheses)' do
    src = '(1+2)'
    assert_equal src, build(src).to_ruby
  end
  
  # logical
  
  define_method :'test operator: 1 && 2 (&& / strong logical and)' do
    assert_binary_operator :'&&'
  end
  
  define_method :'test operator: 1 || 2 (|| / strong logical or)' do
    assert_binary_operator :'||'
  end
  
  define_method :'test binary: 1 and 2 (and / weak logical and)' do
    assert_binary_operator :'and'
  end
  
  define_method :'test binary: 1 or 2 (or / weak logical or)' do
    assert_binary_operator :'or'
  end
  
  define_method :'test operator: (1 and 2) (and, parentheses)' do
    src = '(1 and 2)'
    assert_equal src, build(src).to_ruby
  end
  
  # bitwise
  
  define_method :'test operator: 1 << 2 (<< / left-shift)' do
    assert_binary_operator :'<<'
  end
  
  define_method :'test operator: 1 >> 2 (>> / right-shift)' do
    assert_binary_operator :'>>'
  end
  
  define_method :'test binary: 1 & 2 (& / bit-wise and)' do
    assert_binary_operator :'&'
  end
  
  define_method :'test binary: 1 | 2 (| / bit-wise or)' do
    assert_binary_operator :'|'
  end
  
  define_method :'test binary: 1 ^ 2 (^ / bit-wise xor)' do
    assert_binary_operator :'^'
  end
  
  # comparsion, equality, matching
  
  define_method :'test binary: 1 < 2 (comparsion, smaller)' do
    assert_binary_operator :'<'
  end
  
  define_method :'test binary: 1 <= 2 (comparsion, smaller or equal)' do
    assert_binary_operator :'<='
  end
  
  define_method :'test binary: 1 > 2 (comparsion, greater)' do
    assert_binary_operator :'>'
  end
  
  define_method :'test binary: 1 >= 2 (comparsion, greater or equal)' do
    assert_binary_operator :'>='
  end
  
  define_method :'test binary: 1 <=> 2 (spaceship)' do
    assert_binary_operator :'<=>'
  end
  
  define_method :'test binary: 1 == 2 (equals)' do
    assert_binary_operator :'=='
  end
  
  define_method :'test binary: 1 != 2 (not equals)' do
    assert_binary_operator :'!='
  end
  
  define_method :'test binary: 1 === 2 (threequals)' do
    assert_binary_operator :'==='
  end
  
  define_method :'test binary: 1 =~ 2 (matches)' do
    assert_binary_operator :'=~'
  end
  
  define_method :'test binary: 1 !~ 2 (not matches)' do
    assert_binary_operator :'=~'
  end
  
  # TERNARY
  
  define_method :'test ternary: 1 == 1 ? 2 : 3 (ifop)' do
    src = '1 == 1 ? 2 : 3'
    expr = build(src).first
  
    assert_equal Ruby::IfOp, expr.class
    assert_equal src, build(src).to_ruby
  end
  
  define_method :'test ternary: ((1) ? 2 : (3)) (ifop, parentheses)' do
    src = '((1) ? 2 : (3))'
    assert_equal src, build(src).to_ruby
  end
  
  # ======
  
  define_method :'test operator order in an expression with multiple identical operators' do
    src = 'foo + bar  + baz'
    expr = build(src).first
    assert_equal src, expr.to_ruby
    # FIXME positions are messed up!
    # assert_equal [0, 4], expr.left.operator.position.to_a
    # assert_equal [0, 10], expr.operator.position.to_a
  end
  
  define_method :'test operator order in an expression with multiple different operators' do
    src = 'foo + bar - baz'
    assert_equal src, build(src).to_ruby
  end
  
  define_method :'test operator order in an expression with multiple ternary operators (1)' do
    src = "a ? b : c ? d : e"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :'test operator order in an expression with multiple ternary operators (2)' do
    src = "a ? b ? c : d : e"
    assert_equal src, build(src).to_ruby(true)
  end
end