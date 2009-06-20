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
  
  define_method :"test call arguments, 3 arguments and parantheses" do
    src = "('a' , 'b', :c => :c)"
    args = build('t' + src).first.arguments
  
    assert_equal Ruby::ArgsList, args.class
    assert_equal src, args.to_ruby
    assert_equal src, args.src
  
    assert_equal '(', args.ldelim.token
    assert_equal ')', args.rdelim.token
    assert_equal '',  args.ldelim.whitespace.to_s
  
    assert_equal 2,   args.separators.length
    assert_equal ',', args.separators[0].token
    assert_equal ' ', args.separators[0].whitespace.to_s
    assert_equal ',', args.separators[1].token
    assert_equal '',  args.separators[1].whitespace.to_s
  
    assert_equal [0, 1], args.position.to_a
    assert_equal 21, args.length
  end
  
  define_method :'test call arguments: t(:a => a, :b => b, &block)' do
    src = 't(:a => a, :b => b, &c)'
    call = build(src).first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test call arguments: t("foo") (string, no parentheses)' do
    src = 'foo'
    args = build('t ' + src).first.arguments
  
    assert_equal Ruby::ArgsList, args.class
    assert_equal src, args.to_ruby
    assert_equal src, args.src
  end
  
  define_method :"test call arguments: t :foo, :bar, :baz (3 symbols, no parantheses)" do
    src = ":foo, :bar, :baz"
    args = build('t ' + src).first.arguments
  
    assert_equal Ruby::ArgsList, args.class
    assert_equal src, args.to_ruby
    assert_equal src, args.src
  end
  
  define_method :"test method call: t(:foo => :bar, :baz => :buz) (bare hash)" do
    src = "(:foo => :bar, :baz => :buz)"
    args = build('t' + src).first.arguments
  
    assert_equal Ruby::ArgsList, args.class
    assert_equal src, args.to_ruby
    assert_equal src, args.src
  end
  
  define_method :"test method call: t({ :foo => :bar, :baz => :buz }) (hash)" do
    src = "({ :foo => :bar, :baz => :buz })"
    args = build('t' + src).first.arguments
  
    assert_equal Ruby::ArgsList, args.class
    assert_equal src, args.to_ruby
    assert_equal src, args.src
  end
  
  define_method :"test method call: t([:foo, :bar]) (array)" do
    src = "([:foo, :bar, :baz])"
    args = build('t' + src).first.arguments
  
    assert_equal Ruby::ArgsList, args.class
    assert_equal src, args.to_ruby
    assert_equal src, args.src
  end
  
  define_method :"test method call: t(nil) (keyword)" do
    src = "(nil)"
    args = build('t' + src).first.arguments
  
    assert_equal Ruby::ArgsList, args.class
    assert_equal src, args.to_ruby
    assert_equal src, args.src
  end
  
  define_method :"test: replace argument" do
    src = "(:foo, :bar)"
    args = build('t' + src).first.arguments
    foo, bar = args
  
    args[0] = baz = Ruby::Symbol.from_native(:baz)
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