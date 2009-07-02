require File.dirname(__FILE__) + '/../test_helper'

class CallTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test a variable" do
    src = "t"
    assert_build(src) do |node|
      assert_equal Ruby::Variable, node.first.class
    end
  end
  
  define_method :"test call on const target without arguments and without parantheses" do
    src = "I18n.t"
    assert_build(src) do |node|
      assert_equal Ruby::Call, node.first.class
    end
  end
  
  define_method :'test method call: a.b(:foo) (var ref target, parantheses)' do
    src = "a.b(:foo)"
    assert_build(src)
  end
  
  define_method :"test call on const target without arguments and with parantheses" do
    src = "I18n.t()"
    assert_build(src)
  end
  
  define_method :'test method call: I18n.t("foo") (const target, double-quoted string, parantheses)' do
    src = "I18n.t('foo')"
    assert_build(src)
  end
  
  define_method :'test method call: I18n.t "foo" (const target, double-quoted string, no parantheses)' do
    src = "I18n.t 'foo'"
    assert_build(src)
  end
  
  define_method :"test call on const target without arguments and without parantheses (:: separator)" do
    src = "I18n::t"
    assert_build(src)
  end
  
  define_method :"test call on const target without arguments and with parantheses (:: separator)" do
    src = "I18n::t()"
    assert_build(src)
  end
  
  define_method :'test method call: I18n::t("foo") (const target, double-quoted string, parantheses, :: separator)' do
    src = "I18n::t('foo')"
    assert_build(src)
  end
    
  define_method :'test method call: foo.<=>(bar) (sending an operator, srsly ... used in Rake 0.8.3)' do
    src = "foo.<=>(bar)"
    assert_build(src)
  end
    
  define_method :'test method call: foo.<< bar (sending an operator, srsly ... used in Redmine)' do
    src = "foo.<< bar"
    assert_build(src)
  end
  
  define_method :"test call with a string with an embedded expression" do
    src = 'foo("#{bar}")'
    assert_build(src)
  end
  
  define_method :"test call on no target without arguments but parantheses" do
    src = "t('foo', 'bar')"
    assert_build(src)
  end
  
  define_method :"test two method calls: t('foo'); t 'bar' (no target)" do
    src = "t('foo', 'bar'); t 'baz'"
    assert_build(src)
  end
  
  define_method :'test method call: t "foo" (no target, double-quoted string, no parantheses)' do
    src = "t 'foo'"
    assert_build(src)
  end
  
  define_method :'test method call: t %(foo) (no target, two percent-parentheses delimited strings w/ embedded expression)' do
    src = 't %(foo #{bar}), %(baz)'
    assert_build(src)
  end
  
  define_method :"test call on no target without arguments but parantheses" do
    src = "t()"
    assert_build(src)
  end
  
  define_method :"test call with nested call/parantheses" do
    src = "t(:a, b(:b))"
    assert_build(src)
  end
  
  define_method :"test call with nested call/parantheses" do
    src = "t(:a, b(:b))"
    assert_build(src)
  end
  
  define_method :"test call with a symbol that is a backtick" do
    src = "t(:`)"
    assert_build(src)
  end
  
  define_method :"test call on no target without arguments but a block" do
    src = "t do |a, b, *c|\nfoo\nend"
    assert_build(src)
  end
  
  define_method :"test call on no target without arguments but a block" do
    src = "t do |(a, b), *c|\nfoo\nend"
    assert_build(src)
  end
  
  define_method :"test call on no target with a block var" do
    src = "t(:foo, &block)"
    assert_build(src)
  end
  
  define_method :"test call with a call with a block as an arg" do
    src = "foo(bar do |a| ; end)"
    assert_build(src)
  end
  
  define_method :"test call to self" do
    src = "self.b"
    assert_build(src)
  end
  
  define_method :"test call super without arguments" do
    src = "super"
    assert_build(src)
  end
  
  define_method :"test call super with arguments" do
    src = "super(:foo)"
    assert_build(src)
  end
  
  define_method :"test call yield without arguments" do
    src = "yield"
    assert_build(src)
  end
  
  define_method :"test call yield with arguments" do
    src = "yield(:foo)"
    assert_build(src)
  end
  
  define_method :"test call alias with identifiers" do
    src = "alias eql? =="
    assert_build(src)
  end
  
  define_method :"test call alias with symbols" do
    src = "alias :foo :bar"
    assert_build(src)
  end
  
  define_method :"test call alias with global vars" do
    src = "alias $ERROR_INFO $!"
    assert_build(src)
  end
  
  define_method :"test call undef with a symbol" do
    src = "undef :foo"
    assert_build(src)
  end
  
  define_method :"test call undef with method names" do
    src = "undef foo, bar, baz"
    assert_build(src)
  end
  
  define_method :"test call undef with an operator" do
    src = "undef =~"
    assert_build(src)
  end
  
  define_method :"test call return" do
    src = "return :foo"
    assert_build(src)
  end
  
  define_method :"test call next" do
    src = "next"
    assert_build(src)
  end
  
  define_method :"test call redo" do
    src = "redo"
    assert_build(src)
  end
  
  define_method :"test call break" do
    src = "break"
    assert_build(src)
  end
  
  define_method :"test call retry" do
    src = "retry"
    assert_build(src)
  end
  
  define_method :"test call to an assignment method: a.b = :c" do
    src = "a.b = :c"
    assert_build(src)
  end
  
  define_method :"test call to defined?" do
    src = "defined?(A)"
    assert_build(src)
  end
  
  define_method :'test BEGIN routine' do
    src = "BEGIN { foo }"
    assert_build(src)
  end
  
  define_method :'test END routine' do
    src = "END { foo }"
    assert_build(src)
  end
end