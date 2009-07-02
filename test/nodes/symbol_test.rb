require File.dirname(__FILE__) + '/../test_helper'

class SymbolTest < Test::Unit::TestCase
  include TestHelper

  def assert_symbol(src, value = nil, klass = Ruby::Symbol)
    assert_build(src) do |node|
      assert_equal klass, node.first.class
      assert_equal value, node.first.value if value
    end
  end

  define_method :"test a symbol" do
    src = ':foo'
    assert_symbol(src, :foo)
  end
  
  define_method :"test a symbol that is an operator" do
    src = ':!'
    assert_symbol(src, :!)
  end
  
  define_method :"test a symbol that is wtf" do
    src = ':-@'
    assert_symbol(src, :-@)
  end
  
  define_method :'test a symbol that is also a keyword' do
    src = ":if"
    assert_symbol(src, :if)
  end
  
  define_method :"test a symbol that is an array access operator" do
    src = ':[]'
    assert_symbol(src, :[])
  end
  
  define_method :"test a symbol that is an array assignment operator" do
    src = ':[]='
    assert_symbol(src, :[]=)
  end
  
  define_method :"test a double-quoted dyna-symbol" do
    src = ':"foo.bar"'
    assert_symbol(src, :'foo.bar', Ruby::DynaSymbol)
  end
  
  define_method :"test a single-quoted dyna-symbol" do
    src = ":'foo.bar'"
    assert_symbol(src, :'foo.bar', Ruby::DynaSymbol)
  end
  
  define_method :"test a double-quoted dyna-symbol w/ an embedded expression" do
    src = ':"@#{token}"'
    assert_symbol(src, nil, Ruby::DynaSymbol)
  end
end