require File.dirname(__FILE__) + '/../test_helper'

class ConstTest < Test::Unit::TestCase
  include TestHelper
  
  define_method :"test a const" do
    src = 'A'
    assert_node(src) do |node|
      assert_equal Ruby::Const, node.first.class
    end
  end
  
  define_method :"test a module" do
    src = "module A::B ; end"
    assert_node(src) do |node|
      assert_equal Ruby::Module, node.first.class
    end
  end
  
  define_method :"test a class" do
    src = "class A::B < C ; end"
    assert_node(src) do |node|
      assert_equal Ruby::Class, node.first.class
    end
  end
  
  define_method :"test const on self.class" do
    src = 'self.class::A'
    assert_node(src)
  end
  
  define_method :"test a metaclass" do
    src = "class << self; self; end"
    assert_node(src)
  end
  
  define_method :"test a metaclass inside of a call" do
    src = "foo (class << @bar; self; end)"
    assert_node(src)
  end
  
  define_method :"test a top-level const ref after a class def" do
    src = "class A ; end\n::B = 3"
    assert_node(src)
  end
end