require File.dirname(__FILE__) + '/../test_helper'

class MethodTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test a method" do
    src = "def foo(a, b = nil, c = :foo, *d, &block)\n        bar\n        baz\n      end"
    method = build(src).first
    assert_equal src, method.to_ruby
    assert_equal src, method.src
  end
  
  define_method :"test a method with an options hash" do
    src = "def foo(a, b = {})\nend"
    method = build(src).first
    assert_equal src, method.to_ruby
    assert_equal src, method.src
  end
  
  define_method :"test a class method" do
    src = "def self.foo(a, b = nil, c = :foo, *d, &block)\n        bar\n        baz\n      end"
    method = build(src).first
    assert_equal src, method.to_ruby
    assert_equal src, method.src
  end
  
  define_method :"test method definition: def foo(b = :b, c=:c); end (optional args w/ whitespace differences)" do
    src = 'def foo(a = 1, b=2); end'
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test method definition: def t(a = []); end" do
    src = "def t(a = []) end"
    method = build(src).statements.first
    assert_equal src, method.to_ruby
  end
  
  define_method :"test: method definition: def t(*) end (a single star)" do
    src = "def t(*) end"
    call = build(src).statements.first
    assert_equal src, call.to_ruby
  end
  
  define_method :"test method definition: def <<()" do
    src = "def <<(arg) end"
    method = build(src).statements.first
    assert_equal src, method.to_ruby
  end
  
  define_method :"test method body w/ statements separated by semicolon" do
    src = "def <<(arg) foo; bar; end"
    method = build(src).statements.first
    assert_equal src, method.to_ruby
  end
  
  define_method :"test method body rescue with error var" do
    src = "def t\nrescue => e\nend"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test method body rescue and ensure block" do
    src = "def a(b, c)\n  d\nrescue A\n e\nensure\nb\nend"
    method = build(src).statements.first
    assert_equal src, method.to_ruby
  end

  define_method :"test a method definition with a semicolon and a block in the body" do
    src = "def foo ; bar { |k, v| k }  end"
    method = build(src).first
    assert_equal src, method.to_ruby
    assert_equal src, method.src
  end
end