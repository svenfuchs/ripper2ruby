require File.dirname(__FILE__) + '/../test_helper'

class RipperToRubyNumbersTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  @@space = "  \n  "
  
  define_method :'test an integer: 1' do
    src = @@space + '1'
    program = build(src)
    int = program.statements.first
  
    assert_equal program, int.parent
    assert_equal Ruby::Integer, int.class
    assert_equal 1, int.value
    assert_equal '1', int.to_ruby
  
    assert_equal src, int.root.src
  
    assert_equal [1, 2], int.position
    assert_equal 1, int.row
    assert_equal 2, int.column
    assert_equal 1, int.length
  end
  
  define_method :'test an float: 1.1' do
    src = @@space + '1.1'
    program = build(src)
    float = program.statements.first
  
    assert_equal program, float.parent
    assert_equal Ruby::Float, float.class
    assert_equal 1.1, float.value
    assert_equal '1.1', float.to_ruby
  
    assert_equal src, float.root.src
  
    assert_equal [1, 2], float.position
    assert_equal 1, float.row
    assert_equal 2, float.column
    assert_equal 3, float.length
  end
end