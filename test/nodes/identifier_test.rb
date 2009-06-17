require File.dirname(__FILE__) + '/../test_helper'

class IdentifierTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test a variable" do
    src = 'foo'
    identifier = build(src).first
    assert identifier.is_a?(Ruby::Variable)
    assert_equal src, identifier.to_ruby
    assert_equal src, identifier.src
  end
  
  define_method :"test an instance variable" do
    src = '@foo'
    identifier = build(src).first
    assert identifier.is_a?(Ruby::Variable)
    assert_equal src, identifier.to_ruby
    assert_equal src, identifier.src
  end
  
  define_method :"test a class variable" do
    src = '@@foo'
    identifier = build(src).first
    assert identifier.is_a?(Ruby::Variable)
    assert_equal src, identifier.to_ruby
    assert_equal src, identifier.src
  end
  
  define_method :"test a global variable" do
    src = '$foo'
    identifier = build(src).first
    assert identifier.is_a?(Ruby::Variable)
    assert_equal src, identifier.to_ruby
    assert_equal src, identifier.src
  end
  
  define_method :"test keyword __FILE__" do
    src = '__FILE__'
    identifier = build(src).first
    assert identifier.is_a?(Ruby::Keyword)
    assert_equal src, identifier.to_ruby
    assert_equal src, identifier.src
  end
  
  define_method :"test keyword __LINE__" do
    src = '__LINE__'
    identifier = build(src).first
    assert identifier.is_a?(Ruby::Keyword)
    assert_equal src, identifier.to_ruby
    assert_equal src, identifier.src
  end
  
  define_method :"test keyword __ENCODING__" do
    src = '__ENCODING__'
    identifier = build(src).first
    assert identifier.is_a?(Ruby::Keyword)
    assert_equal src, identifier.to_ruby
    assert_equal src, identifier.src
  end
end