require File.dirname(__FILE__) + '/../test_helper'

class AssignmentTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test assignment: a = b' do
    src = 'a = b'
    assignment = build(src).first
    
    assert_equal Ruby::Assignment, assignment.class
    assert_equal 'a', assignment.left.token
    assert_equal 'b', assignment.right.token
    
    assert_equal src, assignment.to_ruby
    assert_equal src, assignment.src
  end
  
  define_method :'test assignment: a ||= b' do
    src = 'a ||= b'
    assignment = build(src).first
    
    assert_equal src, assignment.to_ruby
    assert_equal src, assignment.src
  end
  
  define_method :'test assignment: a, b = c' do
    src = 'a, b = c'
    assignment = build(src).first
    
    assert_equal Ruby::Assignment, assignment.class
    assert_equal Ruby::MultiAssignment, assignment.left.class
    assert_equal :left, assignment.left.kind
    assert_equal 'a', assignment.left[0].token
    assert_equal 'b', assignment.left[1].token
    assert_equal 'c', assignment.right.token
    
    assert_equal src, assignment.to_ruby
    assert_equal src, assignment.src
  end
  
  define_method :'test assignment: a, b = c, d' do
    src = 'a, b = c, d'
  
    assignment = build(src).first
    assert_equal Ruby::Assignment, assignment.class
  
    assert_equal Ruby::MultiAssignment, assignment.left.class
    assert_equal :left, assignment.left.kind
    assert_equal 'a', assignment.left[0].token
    assert_equal 'b', assignment.left[1].token
  
    assert_equal Ruby::MultiAssignment, assignment.right.class
    assert_equal :right, assignment.right.kind
    assert_equal 'c', assignment.right[0].token
    assert_equal 'd', assignment.right[1].token
  
    assert_equal src, assignment.to_ruby
    assert_equal src, assignment.src
  end
  
  define_method :'test assignment: a, *b = c' do
    src = 'a, *b = c'
    assignment = build(src).first
    assert_equal Ruby::Assignment, assignment.class
  
    assert_equal src, assignment.to_ruby
    assert_equal src, assignment.src
  end
  
  define_method :'test assignment: a, b = *c' do
    src = 'a, b = *c'
    assignment = build(src).first
    assert_equal Ruby::Assignment, assignment.class
  
    assert_equal src, assignment.to_ruby
    assert_equal src, assignment.src
  end
  
  define_method :'test assignment to namespaced const: A::B = 1' do
    src = 'A::B = 1'
    assignment = build(src).first
    assert_equal Ruby::Assignment, assignment.class
  
    assert_equal src, assignment.to_ruby
    assert_equal src, assignment.src
  end
end