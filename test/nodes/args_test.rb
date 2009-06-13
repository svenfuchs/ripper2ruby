require File.dirname(__FILE__) + '/../test_helper'

class RipperRubyBuilderArgsTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :"test call on no target, 3 arguments and parantheses" do
    src = "t('a' , 'b', :c => :c)"
    call = call(src)
    args = call.arguments
  
    assert args.root.is_a?(Ruby::Program)
  
    assert_equal '(', args.ldelim.token
    assert_equal ')', args.rdelim.token
    assert_equal '',  args.ldelim.whitespace
  
    assert_equal 2,   args.separators.length
    assert_equal ',', args.separators[0].token
    assert_equal ' ', args.separators[0].whitespace
    assert_equal ',', args.separators[1].token
    assert_equal '',  args.separators[1].whitespace
  
    assert_equal [0, 1], args.position
    assert_equal 21, args.length
    assert_equal src, call.to_ruby
  end
  
  define_method :'test method call: t("foo") (double-quoted string)' do
    src = 't("foo")'
    call = call(src)
    args = call.arguments
    string = args.first
  
    assert_equal 'foo', string.first.value
  
    assert_equal call, args.parent
    assert_equal args, string.parent
    assert_equal src, string.root.src
    assert_equal src, call.to_ruby
  end
  
  define_method :"test method call: t('foo') (single-quoted string)" do
    string = arguments("t('foo')").first
    assert_equal 'foo', string.first.value
  end
  
  define_method :"test method call: t(:foo) (symbol)" do
    symbol = arguments("t(:foo)").first
    assert_equal :foo, symbol.value
  end
  
  define_method :'test method call: t(:"foo") (double-quoted symbol)' do
    symbol = arguments('t(:"foo")').first
    assert_equal :foo, symbol.value
  end
  
  define_method :"test method call: t(:'foo') (single-quoted symbol)" do
    symbol = arguments("t(:'foo')").first
    assert_equal :foo, symbol.value
  end
  
  define_method :"test method call: t 'foo' (string, no parantheses)" do
    src = "t 'foo'"
    call = call(src)
    args = call.arguments
    string = args.first
  
    assert_equal 'foo', string.value
  
    assert_equal Ruby::Call, args.parent.class
    assert_equal args, string.parent
    assert_equal src, call.to_ruby
  end
  
  define_method :"test method call: t :foo, :bar, :baz (3 symbols, no parantheses)" do
    src = "t :foo, :bar, :baz"
  
    call = call(src)
    args = call.arguments
    foo, bar, baz = args.args
  
    assert_equal :foo, foo.value
    assert_equal :bar, bar.value
    assert_equal :baz, baz.value
  
    assert_equal Ruby::Call, args.parent.class
    assert_equal args, foo.parent
    assert_equal args, bar.parent
    assert_equal args, baz.parent
    
    assert_equal 2, args.separators.size
    assert_equal src, call.to_ruby
  end
  
  define_method :"test method call: t('foo', 'bar') (two strings)" do
    args = arguments("t('foo', 'bar')")
    assert_equal 'foo', args[0].value
    assert_equal 'bar', args[1].value
  end
  
  define_method :"test method call: t(:foo => :bar, :baz => :buz) (bare hash)" do
    src = "t(:foo => :bar, :baz => :buz)"
    call = build(src).statements.first
    hash = call.arguments.first
  
    assert_equal :foo, hash.assocs[0].key.value
    assert_equal :bar, hash.assocs[0].value.value
    assert_equal :baz, hash.assocs[1].key.value
    assert_equal :buz, hash.assocs[1].value.value
  
    assert_equal src, call.to_ruby
  end
  
  define_method :"test method call: t({ :foo => :bar, :baz => :buz }) (hash)" do
    src = "t({ :foo => :bar, :baz => :buz })"
    call = build(src).statements.first
    hash = call.arguments.first
  
    assert_equal :foo, hash.assocs[0].key.value
    assert_equal :bar, hash.assocs[0].value.value
    assert_equal :baz, hash.assocs[1].key.value
    assert_equal :buz, hash.assocs[1].value.value
  
    assert_equal src, call.to_ruby
  end
  
  define_method :"test method call: t([:foo, :bar]) (array)" do
    src = "t([:foo, :bar, :baz])"
  
    call = build(src).statements.first
    array = call.arguments.first
  
    assert_equal :foo, array[0].value
    assert_equal :bar, array[1].value
    assert_equal :baz, array[2].value
  
    assert_equal src, call.to_ruby
  end
  
  define_method :"test method call: t(nil) (keyword)" do
    src = "t(nil)"
    call = build(src).statements.first
    kw = call.arguments.first
  
    assert_equal nil, kw.value
    assert_equal src, call.to_ruby
  end
  
  define_method :"test method call: t(1) (integer)" do
    src = "t(1)"
    call = build(src).statements.first
    integer = call.arguments.first
  
    assert_equal 1, integer.value
    assert_equal src, call.to_ruby
  end
  
  define_method :"test method call: t(1) (float)" do
    src = "t(1.1)"
    call = build(src).statements.first
    float = call.arguments.first
  
    assert_equal 1.1, float.value
    assert_equal src, call.to_ruby
  end
  
  define_method :"test: replace argument" do
    call = call("t(:foo, :bar)")
    args = call.arguments
    foo, bar = args
  
    baz = Ruby::Symbol.from_native(:baz)
    args[0] = baz
  
    assert_equal args, baz.parent
    assert_equal [0, 2], baz.position
  end

  # TODO
  #
  # define_method :"test: args with a star" do
  #   src = "t(*a.b)"
  #   call = build(src).statements.first
  #   assert_equal src, call.to_ruby
  # end
  # 
  # define_method :"test: args with a star and block" do
  #   src = "t(*a.b { |c| c.d })"
  #   call = build(src).statements.first
  #   assert_equal src, call.to_ruby
  # end
end