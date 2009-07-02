require File.dirname(__FILE__) + '/../test_helper'

class NamespacesTest < Test::Unit::TestCase
  include TestHelper
  
  define_method :'test method definition and call: def A::foo() B::foo(); end (multiple :: separators)' do
    src = "def A::foo() B::foo(); end"
    assert_build(src)
  end
  
  define_method :'test method call: A::B::\nfoo() (multiple :: separators)' do
    src = "C::\nD::foo()"
    assert_build(src)
  end
  
  define_method :"test a const path" do
    src = 'A::B::C'
    assert_build(src)
  end
  
  define_method :"test a const path" do
    src = "A::B::C::\nD"
    assert_build(src)
  end
  
  define_method :"test a const path with toplevel const ref" do
    src = '::A::B'
    assert_build(src)
  end
  
  define_method :"test namespace separator with method call and const argument" do
    src = 'A::foo(B)'
    assert_build(src)
  end
  
  define_method :"test namespace separator in a method definition" do
    src = 'def A::foo(); end'
    assert_build(src)
  end
  
  define_method :"test namespaced const after namespace separator in a method definition" do
    src = "def A::foo(); end\n::B::C"
    assert_build(src)
  end
  
  define_method :"test use const after namespace separator in a method definition" do
    src = "def A::foo()\n    a = B\n  end"
    assert_build(src)
  end
  
  define_method :"test a nested namespaced class" do
    src = "class A < B::C\nclass D\nend\nend"
    assert_build(src)
  end
  
  define_method :"test a class method definition calling a class method (namespace seps)" do
    src = "def A::foo()\nB::foo()\n end"
    assert_build(src)
  end
  
  define_method :"test a class method definition (using const) containing a class method call (using ::)" do
    src = "def A.foo(a, b = nil, c = :foo, *d, &block)\n        A::B()\n        baz\n      end"
    assert_build(src)
  end
end