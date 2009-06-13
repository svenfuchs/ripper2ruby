require File.dirname(__FILE__) + '/../test_helper'

class RipperRubyBuilderCallTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :"test identifier on no target without arguments and without parantheses" do
    # i'm not sure this is correct ... we're skipping :var_ref in ruby_builder
    src = "t"
    program = build(src)
    identifier = program.statements.first
  
    assert_equal 't', identifier.token
  
    assert identifier.root.is_a?(Ruby::Program)
    assert_equal src, identifier.root.src
    assert_equal src, identifier.to_ruby
    assert_equal src, identifier.src
  end
  
  define_method :"test call on const target without arguments and without parantheses" do
    src = "I18n.t"
    program = build(src)
    call = program.statements.first
  
    assert_equal 't', call.identifier.token
    assert !call.arguments
  
    assert call.root.is_a?(Ruby::Program)
    assert_equal src, call.root.src
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call on const target without arguments and with parantheses" do
    src = "I18n.t()"
    program = build(src)
    call = program.statements.first
  
    assert_equal 't', call.identifier.token
    assert call.arguments.empty?
  
    assert call.root.is_a?(Ruby::Program)
    assert_equal src, call.root.src
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test method call: I18n.t("foo") (const target, double-quoted string, parantheses)' do
    src = "I18n.t('foo')"
    program = build(src)
    call = program.statements.first
    arg = call.arguments.first
  
    assert_equal 't', call.identifier.token
    assert_equal 'I18n', call.target.token
    assert_equal 'foo', arg.first.value
  
    assert call.root.is_a?(Ruby::Program)
    assert_equal src, call.root.src
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test method call: I18n.t "foo" (const target, double-quoted string, no parantheses)' do
    src = "I18n.t 'foo'"
    program = build(src)
    call = program.statements.first
    arg = call.arguments.first
  
    assert_equal 't', call.identifier.token
    assert_equal 'I18n', call.target.token
    assert_equal 'foo', arg.first.value
  
    assert call.root.is_a?(Ruby::Program)
    assert_equal src, call.root.src
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test method call: a.b(:foo) (var ref target, parantheses)' do
    src = "a.b(:foo)"
    call = build(src).statements.first
  
    assert_equal 'b', call.identifier.token
    assert_equal 'a', call.target.token
    assert_equal :foo, call.arguments.first.value
  
    assert call.root.is_a?(Ruby::Program)
    assert_equal src, call.root.src
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call on no target without arguments but parantheses" do
    src = "t('a', 'b')"
    call = call(src)
  
    assert_equal 't', call.identifier.token
    assert !call.target
  
    assert_equal src, call.root.src
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test two method calls: t('foo'); t 'bar' (no target)" do
    calls = build("t('foo', 'bar'); t 'baz'").statements.map { |s| s.statement }
  
    assert !calls[0].target
    assert_equal 't', calls[0].identifier.token
    assert_equal "t('foo', 'bar')", calls[0].to_ruby
    assert_equal "t('foo', 'bar')", calls[0].src
  
    assert !calls[1].target
    assert_equal 't', calls[1].identifier.token
    assert_equal "t 'baz'", calls[1].to_ruby
    assert_equal "t 'baz'", calls[1].src
  end
  
  define_method :"test call on no target without arguments but parantheses" do
    src = "t()"
    program = build(src)
    call = program.statements.first
  
    assert_equal 't', call.identifier.token
    assert !call.target
  
    assert call.root.is_a?(Ruby::Program)
    assert_equal src, call.root.src
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call on no target without arguments but a block" do
    src = "t do |a, b, *c|\nfoo\nend"
    program = build(src)
    call = program.statements.first
  
    assert_equal 't', call.identifier.token
    assert !call.target
    assert_equal Ruby::Block, call.block.class
  
    assert call.root.is_a?(Ruby::Program)
    assert_equal src, call.root.src
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call on no target without arguments but a block" do
    src = "t do |(a, b), *c|\nfoo\nend"
    program = build(src)
    call = program.statements.first
  
    assert_equal 't', call.identifier.token
    assert !call.target
    assert_equal Ruby::Block, call.block.class
  
    assert call.root.is_a?(Ruby::Program)
    assert_equal src, call.root.src
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call on no target with a block var" do
    src = "t(:foo, &block)"
    call = build(src).statements.first
    
    assert_equal src, call.to_ruby
    assert_equal [0, 8], call.arguments[1].position
  end
  
  define_method :"test call to an assignment method: a.b = :c" do
    src = "a.b = :c"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
  end
end