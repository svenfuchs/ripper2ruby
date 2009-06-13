require File.dirname(__FILE__) + '/../test_helper'

class RipperToRubySymbolTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  @@space = "  \n  "

  define_method :"test a symbol: :foo" do
    src = "    \n  \n :foo"
    symbol = node(src, Ruby::Symbol)

    assert symbol.is_a?(Ruby::Symbol)
    assert symbol.parent.is_a?(Ruby::Program)
    
    assert_equal ":foo", symbol.to_ruby
    assert_equal :foo, symbol.value

    assert_equal ':', symbol.ldelim.token
    assert_equal 'foo', symbol.token
    assert_equal "    \n  \n ", symbol.whitespace
    assert_equal [2, 1], symbol.position

    assert_equal 4, symbol.length
    assert_equal 9, symbol.src_pos
    assert_equal :foo, symbol.value
    assert_equal ':foo', symbol.src
    assert_equal ':foo', symbol.to_ruby
    assert_equal src, symbol.to_ruby(true)

    assert_equal 13, symbol.length(true)
    assert_equal 0, symbol.src_pos(true)
    assert_equal src, symbol.src(true)
    
    assert_equal [2, 1], symbol.position
    assert_equal 2, symbol.row
    assert_equal 1, symbol.column
  end
  

  define_method :"test a single-quoted dyna-symbol: :'foo'" do
    src = "    \n  \n :'foo'"
    symbol = node(src, Ruby::DynaSymbol)
  
    assert symbol.is_a?(Ruby::DynaSymbol)
    assert symbol.parent.is_a?(Ruby::Program)
    
    assert_equal :foo, symbol.value
    assert_equal src, symbol.root.src
  
    assert_equal ":'", symbol.ldelim.token
    assert_equal "'", symbol.rdelim.token
    assert_equal "    \n  \n ", symbol.ldelim.whitespace
    assert_equal [2, 1], symbol.position
  
    assert_equal 6, symbol.length
    assert_equal 9, symbol.src_pos
    assert_equal ":'foo'", symbol.src
    assert_equal ":'foo'", symbol.to_ruby
  
    assert_equal 15, symbol.length(true)
    assert_equal 0, symbol.src_pos(true)
    assert_equal src, symbol.src(true)
  
    assert_equal [2, 1], symbol.position
    assert_equal 2, symbol.row
    assert_equal 1, symbol.column
  end
  
  define_method :'test a double-quoted symbol: :"foo"' do
    src = "    \n  \n :\"foo\""
    symbol = node(src, Ruby::DynaSymbol)
  
    assert symbol.is_a?(Ruby::DynaSymbol)
    assert symbol.parent.is_a?(Ruby::Program)
    
    assert_equal :foo, symbol.value
    assert_equal src, symbol.root.src
    assert_equal ':"foo"', symbol.to_ruby
    # assert_equal src, symbol.to_ruby(true)
  
    assert_equal [2, 1], symbol.position
    assert_equal 2, symbol.row
    assert_equal 1, symbol.column
    assert_equal 6, symbol.length
  end
  
  define_method :'test a symbol using an operator' do
    assert_equal :!, build(":!").statements.first.value
  end
end