require File.dirname(__FILE__) + '/../test_helper'

class SymbolTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test a symbol" do
    src = ':foo'
    symbol = build(src).first
    assert symbol.is_a?(Ruby::Symbol)
    assert_equal :foo, symbol.value
    assert_equal src, symbol.to_ruby
  end

  define_method :"test a symbol (non-word character)" do
    src = ':!'
    symbol = build(src).first
    assert symbol.is_a?(Ruby::Symbol)
    assert_equal :!, symbol.value
    assert_equal src, symbol.to_ruby
  end

  define_method :"test a double-quoted dyna-symbol" do
    src = ':"foo.bar"'
    symbol = build(src).first
    assert symbol.is_a?(Ruby::DynaSymbol)
    assert_equal :'foo.bar', symbol.value
    assert_equal src, symbol.to_ruby
  end
  
  define_method :"test a single-quoted dyna-symbol" do
    src = ":'foo.bar'"
    symbol = build(src).first
    assert symbol.is_a?(Ruby::DynaSymbol)
    assert_equal :'foo.bar', symbol.value
    assert_equal src, symbol.to_ruby
  end
end