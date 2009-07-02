require File.dirname(__FILE__) + '/../test_helper'

class MethodTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test a method definition" do
    src = "def foo(a, b = nil, c = :foo, *d, &block)\n        bar\n        baz\n      end"
    assert_build(src)
  end
  
  define_method :"test a method definition with an options hash" do
    src = "def foo(a, b = {})\nend"
    assert_build(src)
  end
  
  define_method :"test a method definition without parentheses" do
    src = "def foo a, b = nil, c = :foo, *d, &block\n        bar\n        baz\n      end"
    assert_build(src)
  end
  
  define_method :"test a class method definition (using self, keyword)" do
    src = "def self.for(options)\nend"
    assert_build(src)
  end
  
  define_method :"test method definition: def foo(b = :b, c=:c); end (optional args w/ whitespace differences)" do
    src = 'def foo(a = 1, b=2); end'
    assert_build(src)
  end
  
  define_method :"test method definition: def t(a = []); end" do
    src = "def t(a = []) end"
    assert_build(src)
  end
  
  define_method :"test: method definition: def t(*) end (a single splat)" do
    src = "def t(*) end"
    assert_build(src)
  end
  
  define_method :"test method definition: def <<()" do
    src = "def <<(arg) end"
    assert_build(src)
  end
  
  define_method :"test method definition: def | " do
    src = "def | ; end"
    assert_build(src)
  end
  
  define_method :"test method definition: def |(foo) " do
    src = "class A < B; def |(foo); end; end"
    assert_build(src)
  end
  
  define_method :"test method body w/ statements separated by semicolon" do
    src = "def <<(arg) foo; bar; end"
    assert_build(src)
  end
  
  define_method :"test method body rescue with error var" do
    src = "def t\nrescue => e\nend"
    assert_build(src)
  end
  
  define_method :"test method body rescue and ensure block" do
    src = "def a(b, c)\n  d\nrescue A\n e\nensure\nb\nend"
    assert_build(src)
  end
  
  define_method :"test a method definition with a semicolon and a block in the body" do
    src = "def foo ; bar { |k, v| k }  end"
    assert_build(src)
  end
  
  define_method :"test a method definition with an identifier that is also a keyword (?) (class)" do
    src = "class A\n  def class\n  end\nend"
    assert_build(src)
  end
  
  define_method :"test a method definition with an identifier that is also a keyword (?) (end)" do
    src = "def end\nend"
    assert_build(src)
  end
  
  define_method :"test a method definition that returns a number" do
    src = "def def; 234; end"
    assert_build(src)
  end
  
  
end