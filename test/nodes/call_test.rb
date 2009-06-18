require File.dirname(__FILE__) + '/../test_helper'

class CallTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test a variable" do
    src = "t"
    variable = build(src).first
  
    assert_equal Ruby::Variable, variable.class
    assert_equal 't', variable.token
    assert_equal src, variable.to_ruby
    assert_equal src, variable.src
  end
  
  define_method :"test call on const target without arguments and without parantheses" do
    src = "I18n.t"
    call = build(src).first
  
    assert_equal Ruby::Call, call.class
    assert_equal 't', call.identifier.token
    assert_equal nil, call.arguments
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call on const target without arguments and with parantheses" do
    src = "I18n.t()"
    call = build(src).first
  
    assert_equal Ruby::Call, call.class
    assert_equal 't', call.identifier.token
    assert call.arguments.empty?
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test method call: I18n.t("foo") (const target, double-quoted string, parantheses)' do
    src = "I18n.t('foo')"
    call = build(src).first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test method call: I18n.t "foo" (const target, double-quoted string, no parantheses)' do
    src = "I18n.t 'foo'"
    call = build(src).first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test method call: foo.<=>(bar) (sending an operator, srsly ... used in Rake 0.8.3)' do
    src = "foo.<=>(bar)"
    call = build(src).first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test method call: a.b(:foo) (var ref target, parantheses)' do
    src = "a.b(:foo)"
    call = build(src).first
  
    assert_equal Ruby::Call, call.class
    assert_equal 'b', call.identifier.token
    assert_equal 'a', call.target.token
    assert_equal :foo, call.arguments.first.value
  
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call on no target without arguments but parantheses" do
    src = "t('foo', 'bar')"
    call = build(src).first
  
    assert_equal Ruby::Call, call.class
    assert_equal 't', call.identifier.token
    assert_equal nil, call.target
    assert_equal 'foo', call.arguments.first.value
  
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test two method calls: t('foo'); t 'bar' (no target)" do
    src = "t('foo', 'bar'); t 'baz'"
    program = build(src)
    foo, baz = program.statements
  
    assert_equal Ruby::Call, foo.class
    assert_equal nil, foo.target
    assert_equal 't', foo.identifier.token
    assert_equal "t('foo', 'bar')", foo.to_ruby
    assert_equal "t('foo', 'bar')", foo.src
  
    assert_equal nil, baz.target
    assert_equal 't', baz.identifier.token
    assert_equal "t 'baz'", baz.to_ruby
    assert_equal "t 'baz'", baz.src
  
    assert_equal src, program.to_ruby
    assert_equal src, program.src
  end
  
  define_method :"test call on no target without arguments but parantheses" do
    src = "t()"
    call = build(src).first
  
    assert_equal Ruby::Call, call.class
    assert_equal nil, call.target
    assert_equal 't', call.identifier.token
  
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call with nested call/parantheses" do
    src = "a(:a, b(:b))"
    call = build(src).first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call on no target without arguments but a block" do
    src = "t do |a, b, *c|\nfoo\nend"
    call = build(src).first
  
    assert_equal Ruby::Call, call.class
    assert_equal 't', call.identifier.token
    assert_equal nil, call.target
    assert_equal Ruby::Block, call.block.class
  
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call on no target without arguments but a block" do
    src = "t do |(a, b), *c|\nfoo\nend"
    call = build(src).first
  
    assert_equal Ruby::Call, call.class
    assert_equal 't', call.identifier.token
    assert_equal nil, call.target
    assert_equal Ruby::Block, call.block.class
  
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call on no target with a block var" do
    src = "t(:foo, &block)"
    call = build(src).first
    
    assert_equal src, call.to_ruby
    assert_equal [0, 8], call.arguments[1].position
  end
  
  define_method :"test call to self" do
    src = "self.b"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call super without arguments" do
    src = "super"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call super with arguments" do
    src = "super(:foo)"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call yield without arguments" do
    src = "yield"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call yield with arguments" do
    src = "yield(:foo)"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call alias with identifiers" do
    src = "alias eql? =="
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call alias with symbols" do
    src = "alias :foo :bar"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call alias with global vars" do
    src = "alias $ERROR_INFO $!"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call undef with a symbol" do
    src = "undef :foo"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call undef with a method name" do
    src = "undef puts"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call undef with an operator" do
    src = "undef =~"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call return" do
    src = "return :foo"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call next" do
    src = "next"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call redo" do
    src = "redo"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call break" do
    src = "break"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call retry" do
    src = "retry"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call to an assignment method: a.b = :c" do
    src = "a.b = :c"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test call to defined?" do
    src = "defined?(A)"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :'test BEGIN routine' do
    src = "BEGIN { foo }"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
  
  define_method :'test END routine' do
    src = "END { foo }"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
end