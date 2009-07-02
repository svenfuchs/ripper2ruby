require File.dirname(__FILE__) + '/../test_helper'

class AssignmentTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test assignment: a = b' do
    src = 'a = b'
    assert_build(src) do |node|
      assert_equal Ruby::Assignment, node.first.class
    end
  end
  
  define_method :'test assignment: a ||= b' do
    src = 'a ||= b'
    assert_build(src)
  end
  
  define_method :'test assignment: a, b = c' do
    src = 'a, b = c'
    assert_build(src) do |node|
      assert_equal Ruby::Assignment, node.first.class
      assert_equal Ruby::MultiAssignment, node.first.left.class
    end
  end
  
  define_method :'test assignment: a, b = c, d' do
    src = 'a, b = c, d'
    assert_build(src) do |node|
      assert_equal Ruby::Assignment, node.first.class
      assert_equal Ruby::MultiAssignment, node.first.left.class
      assert_equal Ruby::MultiAssignment, node.first.right.class
    end
  end
  
  define_method :'test assignment: a, *b = c' do
    src = 'a, *b = c'
    assert_build(src)
  end
  
  define_method :'test assignment: a, b = *c' do
    src = 'a, b = *c'
    assert_build(src)
  end
  
  define_method :'test assignment to namespaced const: A::B = 1' do
    src = 'A::B = 1'
    assert_build(src)
  end
end