require File.dirname(__FILE__) + '/../test_helper'

class IdentifierTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test a variable" do
    src = 'foo'
    identifier = build(src).first
    assert_build(src) do |node|
      assert_equal Ruby::Variable, node.first.class
    end
  end
  
  define_method :"test an instance variable" do
    src = '@foo'
    assert_build(src) do |node|
      assert_equal Ruby::Variable, node.first.class
    end
  end
  
  define_method :"test a class variable" do
    src = '@@foo'
    assert_build(src) do |node|
      assert_equal Ruby::Variable, node.first.class
    end
  end
  
  define_method :"test a global variable" do
    src = '$foo'
    assert_build(src) do |node|
      assert_equal Ruby::Variable, node.first.class
    end
  end
  
  define_method :"test keyword __FILE__" do
    src = '__FILE__'
    assert_build(src) do |node|
      assert_equal Ruby::Keyword, node.first.class
    end
  end
  
  define_method :"test keyword __LINE__" do
    src = '__LINE__'
    assert_build(src)
  end
  
  define_method :"test keyword __ENCODING__" do
    src = '__ENCODING__'
    assert_build(src)
  end
end