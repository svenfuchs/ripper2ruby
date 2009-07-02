require File.dirname(__FILE__) + '/../test_helper'

class ArgsTest < Test::Unit::TestCase
  include TestHelper
  
  define_method :"test call arguments positions" do
    src = "t('a' , 'b', 'c' => 'd', &e) { |f| g }"
    assert_build(src) do |node|
      assert_equal Ruby::ArgsList, node.first.arguments.class
      assert_position [0, 0],  node.select(:token => 't')
      assert_position [0, 1],  node.select(:token => '(')
      assert_position [0, 2],  node.select(:value => 'a')
      assert_position [0, 6],  node.select(:token => ',')
      assert_position [0, 8],  node.select(:value => 'b')
      assert_position [0, 13], node.select(:value => 'c')
      assert_position [0, 17], node.select(:token => '=>')
      assert_position [0, 20], node.select(:value => 'd')
      assert_position [0, 25], node.select(Ruby::Arg).last
      assert_position [0, 27], node.select(:token => ')')
      assert_position [0, 29], node.select(:token => '{')
      assert_position [0, 31], node.select(:token => '|')[0]
      assert_position [0, 32], node.select(:token => 'f')
      assert_position [0, 33], node.select(:token => '|')[1]
      assert_position [0, 35], node.select(:token => 'g')
      assert_position [0, 37], node.select(:token => '}')
    end
  end

  define_method :'test call arguments: t("foo") (string)' do
    src = 't("foo")'
    assert_build(src)
  end
  
  define_method :'test call arguments: t(:a => a, :b => b, &block)' do
    src = 't(:a => a, :b => b, &c)'
    assert_build(src) do |node|
    end
  end
  
  define_method :'test call arguments: t("foo") (string, no parentheses)' do
    src = 't foo'
    assert_build(src)
  end
  
  define_method :"test call arguments: t :foo, :bar, :baz (3 symbols, no parentheses)" do
    src = "t :foo, :bar, :baz"
    assert_build(src)
  end
  
  define_method :"test method call: t(:foo => :bar, :baz => :buz) (bare hash)" do
    src = "t(:foo => :bar, :baz => :buz)"
    assert_build(src)
  end
  
  define_method :"test method call: t :a => :a do end (bare hash, no parentheses, do block)" do
    src = "t :a => :a do end"
    assert_build(src)
  end
  
  define_method :"test method call: t({ :foo => :bar, :baz => :buz }) (hash)" do
    src = "t({ :foo => :bar, :baz => :buz })"
    assert_build(src)
  end
  
  define_method :"test method call: t({ :foo => :bar }) (hash, leading whitespace)" do
    src = 't ({ :foo => :bar })'
    assert_build(src)
  end
  
  define_method :"test method call: t([:foo, :bar]) (array)" do
    src = "(t[:foo, :bar, :baz])"
    assert_build(src)
  end
  
  define_method :"test method call: t(nil) (keyword)" do
    src = "t(nil)"
    assert_build(src)
  end
  
  define_method :"test: args with a splat call" do
    src = "t(*a.b)"
    assert_build(src)
  end
  
  define_method :"test: args with a splat and block" do
    src = "t(*a.b { |c| c.d })"
    assert_build(src)
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