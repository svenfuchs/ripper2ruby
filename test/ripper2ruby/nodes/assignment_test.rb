require File.dirname(__FILE__) + '/../test_helper'

class RipperRubyBuilderAssignmentTest < Test::Unit::TestCase
  def build(src)
    Ripper::RubyBuilder.build(src)
  end
  
  def sexp(src)
    Ripper::SexpBuilder.new(src).parse
  end

  define_method :'test assignment: a = b' do
    src = 'a = b'
    assignment = build(src).statements.first
    assert_equal Ruby::Assignment, assignment.class
    assert_equal 'a', assignment.left.token
    assert_equal 'b', assignment.right.token
    assert_equal src, assignment.to_ruby
  end
  
  define_method :'test assignment: a, b = c' do
    src = 'a, b = c'
    assignment = build(src).statements.first
    assert_equal Ruby::Assignment, assignment.class
    assert_equal Ruby::MultiAssignment, assignment.left.class
    assert_equal :left, assignment.left.kind
    assert_equal 'a', assignment.left[0].token
    assert_equal 'b', assignment.left[1].token
    assert_equal 'c', assignment.right.token
    assert_equal src, assignment.to_ruby
  end
  
  define_method :'test assignment: a, b = c, d' do
    src = 'a, b = c, d'

    assignment = build(src).statements.first
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
  end
  
  define_method :'test assignment: a, b = *c' do
    src = 'a, b = *c'
    assignment = build(src).statements.first
    assert_equal Ruby::Assignment, assignment.class

    assert_equal Ruby::MultiAssignment, assignment.left.class
    assert_equal :left, assignment.left.kind
    assert_equal 'a', assignment.left[0].token
    assert_equal 'b', assignment.left[1].token

    assert_equal Ruby::MultiAssignment, assignment.right.class
    assert_equal :right, assignment.right.kind
    assert_equal '*', assignment.right.star.token
    assert_equal 'c', assignment.right[0].token
    assert_equal src, assignment.to_ruby
  end
end