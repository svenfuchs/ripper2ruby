require File.dirname(__FILE__) + '/../test_helper'

class ConstTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test a const" do
    src = 'A'
    identifier = build(src).first
    assert identifier.is_a?(Ruby::Const)
    assert_equal src, identifier.to_ruby
    assert_equal src, identifier.src
  end
  
  define_method :"test a const path" do
    src = 'A::B::C'
    identifier = build(src).first
    assert identifier.is_a?(Ruby::Const)
    assert_equal src, identifier.to_ruby
    assert_equal src, identifier.src
  end
  
  define_method :"test a class" do
    src = "class A::B < C ; end"
    const = build(src).first

    assert_equal Ruby::Class, const.class
    assert_equal 'B', const.const.token
    assert_equal 'C', const.super_class.token
    assert_equal src, const.to_ruby
    assert_equal src, const.src
  end

  define_method :"test a module" do
    src = "module A::B ; end"
    const = build(src).first

    assert_equal Ruby::Module, const.class
    assert_equal 'B', const.const.token
    assert_equal src, const.to_ruby
    assert_equal src, const.src
  end
end