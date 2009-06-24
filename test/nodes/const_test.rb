require File.dirname(__FILE__) + '/../test_helper'

class ConstTest < Test::Unit::TestCase
  include TestHelper
  # 
  # define_method :"test a const" do
  #   src = 'A'
  #   const = build(src).first
  #   assert_equal Ruby::Const, const.class
  #   assert_equal src, const.to_ruby
  #   assert_equal src, const.src
  # end
  # 
  # define_method :"test a const path" do
  #   src = 'A::B::C'
  #   const = build(src).first
  #   assert_equal Ruby::Const, const.class
  #   assert_equal src, const.to_ruby
  #   assert_equal src, const.src
  # end
  # 
  # define_method :"test a const path" do
  #   src = "A::B::C::\nD"
  #   const = build(src).first
  #   assert_equal Ruby::Const, const.class
  #   assert_equal src, const.to_ruby
  #   assert_equal src, const.src
  # end
  # 
  # define_method :"test a const path with toplevel const ref" do
  #   src = '::A::B'
  #   const = build(src).first
  #   assert_equal Ruby::Const, const.class
  #   assert_equal src, const.to_ruby
  #   assert_equal src, const.src
  # end
  # 
  # define_method :"test a class" do
  #   src = "class A::B < C ; end"
  #   const = build(src).first
  # 
  #   assert_equal Ruby::Class, const.class
  #   assert_equal src, const.to_ruby
  #   assert_equal src, const.src
  # end
  # 
  # define_method :"test a nested namespaced class" do
  #   src = "class A < B::C\nclass D\nend\nend"
  #   assert_equal src, build(src).first.to_ruby
  # end
  # 
  # define_method :"test const on self.class" do
  #   src = 'self.class::A'
  #   assert_equal src, build(src).first.to_ruby
  # end
  # 
  # define_method :"test namespace separator with method call and const argument" do
  #   src = 'A::foo(B)'
  #   assert_equal src, build(src).first.to_ruby
  # end
  # 
  # define_method :"test namespace separator in a method definition" do
  #   src = 'def A::foo(); end'
  #   assert_equal src, build(src).first.to_ruby
  # end
  # 
  # define_method :"test namespaced const after namespace separator in a method definition" do
  #   src = "def A::foo(); end\n::B::C"
  #   assert_equal src, build(src).to_ruby
  # end
  
  define_method :"test use const after namespace separator in a method definition" do
    src = "def A::foo()\n    a = B\n  end"
    assert_equal src, build(src).to_ruby
  end
  
  # define_method :"test a metaclass" do
  #   src = "class << self; self; end"
  #   const = build(src).first
  # 
  #   assert_equal src, const.to_ruby
  #   assert_equal src, const.src
  # end
  # 
  # define_method :"test a module" do
  #   src = "module A::B ; end"
  #   const = build(src).first
  # 
  #   assert_equal Ruby::Module, const.class
  #   assert_equal src, const.to_ruby
  #   assert_equal src, const.src
  # end
end