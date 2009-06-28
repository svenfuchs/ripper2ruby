require File.dirname(__FILE__) + '/../test_helper'

class ArgsTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test call arguments: t("foo") (string)' do
    src = 't("foo")'
    assert_node(src) do |node|
      assert_equal Ruby::ArgsList, node.first.arguments.class
    end
  end
  
  define_method :"test call arguments, 3 arguments and parentheses" do
    src = "t('a' , 'b', :c => :c)"
    assert_node(src)
  end
  
  define_method :'test call arguments: t(:a => a, :b => b, &block)' do
    src = 't(:a => a, :b => b, &c)'
    assert_node(src)
  end
  
  define_method :'test call arguments: t("foo") (string, no parentheses)' do
    src = 't foo'
    assert_node(src)
  end
  
  define_method :"test call arguments: t :foo, :bar, :baz (3 symbols, no parentheses)" do
    src = "t :foo, :bar, :baz"
    assert_node(src)
  end
  
  define_method :"test method call: t(:foo => :bar, :baz => :buz) (bare hash)" do
    src = "t(:foo => :bar, :baz => :buz)"
    assert_node(src)
  end
  
  define_method :"test method call: t :a => :a do end (bare hash, no parentheses, do block)" do
    src = "t :a => :a do end"
    assert_node(src)
  end
  
  define_method :"test method call: t({ :foo => :bar, :baz => :buz }) (hash)" do
    src = "t({ :foo => :bar, :baz => :buz })"
    assert_node(src)
  end
  
  define_method :"test method call: t({ :foo => :bar }) (hash, leading whitespace)" do
    src = 't ({ :foo => :bar })'
    assert_node(src)
  end
  
  define_method :"test method call: t([:foo, :bar]) (array)" do
    src = "(t[:foo, :bar, :baz])"
    assert_node(src)
  end
  
  define_method :"test method call: t(nil) (keyword)" do
    src = "t(nil)"
    assert_node(src)
  end
  
  define_method :"test: args with a splat call" do
    src = "t(*a.b)"
    assert_node(src)
  end
  
  define_method :"test: args with a splat and block" do
    src = "t(*a.b { |c| c.d })"
    assert_node(src)
  end
  
  
  define_method :"test: replace argument" do
    src = "(:foo, :bar)"
    args = build('t' + src).first.arguments
    foo, bar = args
  
    args[0] = baz = Ruby.from_native(:baz)
    assert_equal args, baz.parent.parent # baz is wrapped into an Arg
    assert_equal [0, 2], baz.position.to_a
  end
end