require File.dirname(__FILE__) + '/../test_helper'

class ArgsTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test call arguments: t("foo") (string)' do
    src = '("foo")'
    args = build('t' + src).first.arguments
  
    assert_equal Ruby::ArgsList, args.class
    assert_equal src, args.to_ruby
    assert_equal src, args.src
  end
  
  define_method :"test call arguments, 3 arguments and parentheses" do
    src = "t('a' , 'b', :c => :c)"
    call = build(src)
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test call arguments: t(:a => a, :b => b, &block)' do
    src = 't(:a => a, :b => b, &c)'
    call = build(src)
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test call arguments: t("foo") (string, no parentheses)' do
    src = 't foo'
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test call arguments: t :foo, :bar, :baz (3 symbols, no parentheses)" do
    src = "t :foo, :bar, :baz"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test method call: t(:foo => :bar, :baz => :buz) (bare hash)" do
    src = "t(:foo => :bar, :baz => :buz)"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test method call: t :a => :a do end (bare hash, no parentheses, do block)" do
    src = "t :a => :a do end"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test method call: t({ :foo => :bar, :baz => :buz }) (hash)" do
    src = "t({ :foo => :bar, :baz => :buz })"
    call = build(src)
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test method call: t({ :foo => :bar }) (hash, leading whitespace)" do
    src = 't ({ :foo => :bar })'
    call = build(src)
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end

  define_method :"test method call: t([:foo, :bar]) (array)" do
    src = "([:foo, :bar, :baz])"
    args = build('t' + src).first.arguments
    assert_equal src, args.to_ruby
    assert_equal src, args.src
  end
  
  define_method :"test method call: t(nil) (keyword)" do
    src = "(nil)"
    args = build('t' + src).first.arguments
    assert_equal src, args.to_ruby
    assert_equal src, args.src
  end
  
  define_method :"test: replace argument" do
    src = "(:foo, :bar)"
    args = build('t' + src).first.arguments
    foo, bar = args
  
    args[0] = baz = Ruby.from_native(:baz)
    assert_equal args, baz.parent.parent # baz is wrapped into an Arg
    assert_equal [0, 2], baz.position.to_a
  end
  
  define_method :"test: args with a starred call" do
    src = "t(*a.b)"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
  end
  
  define_method :"test: args with a star and block" do
    src = "t(*a.b { |c| c.d })"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
  end
end