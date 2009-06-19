require File.dirname(__FILE__) + '/../test_helper'

class ConstTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test a const" do
    src = 'A'
    const = build(src).first
    assert_equal Ruby::Const, const.class
    assert_equal src, const.to_ruby
    assert_equal src, const.src
  end
  
  define_method :"test a const path" do
    src = 'A::B::C'
    const = build(src).first
    assert_equal Ruby::Const, const.class
    assert_equal src, const.to_ruby
    assert_equal src, const.src
  end
  
  define_method :"test a const path with toplevel const ref" do
    src = '::A::B'
    const = build(src).first
    assert_equal Ruby::Const, const.class
    assert_equal src, const.to_ruby
    assert_equal src, const.src
  end
  
  define_method :"test a class" do
    src = "class A::B < C ; end"
    const = build(src).first
  
    assert_equal Ruby::Class, const.class
    assert_equal src, const.to_ruby
    assert_equal src, const.src
  end
  
  define_method :"test a metaclass" do
    src = "class << self; self; end"
    const = build(src).first
  
    assert_equal src, const.to_ruby
    assert_equal src, const.src
  end
  
  define_method :"test a module" do
    src = "module A::B ; end"
    const = build(src).first
  
    assert_equal Ruby::Module, const.class
    assert_equal src, const.to_ruby
    assert_equal src, const.src
  end
end