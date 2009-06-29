require File.dirname(__FILE__) + '/test_helper'

class TraversalTest < Test::Unit::TestCase
  include TestHelper
  
  define_method :"test select by token" do
    nodes = build('1 + (1 + (1 + 2))').select(:token => '1')
    assert_equal 3, nodes.size
    assert_equal [Ruby::Integer], nodes.map(&:class).uniq
    assert_equal ['1', '1', '1'], nodes.map(&:token)
  end
  
  define_method :"test select by value" do
    nodes = build('1 + (1 + (1 + 2))').select(:value => 2)
    assert_equal 1, nodes.size
    assert_equal [Ruby::Integer], nodes.map(&:class).uniq
    assert_equal ['2'], nodes.map(&:token)
  end
  
  define_method :"test select by position" do
    nodes = build('1 + (2 + (3 + 4))').select(:position => [0, 10])
    assert_equal 3, nodes.size
    assert_equal [Ruby::Statements, Ruby::Binary, Ruby::Integer], nodes.map(&:class)
    assert_equal '3', nodes.last.token
    assert_equal [0, 10], nodes.last.position.to_a
  end
  
  define_method :"test select by a single klass" do
    nodes = build('1 + (2 + (3 + 4))').select(Ruby::Operator)
    assert_equal 3, nodes.size
    assert_equal [Ruby::Binary], nodes.map(&:class).uniq
    assert_equal '+', nodes.last.operator.token
    assert_equal [0, 10], nodes.last.position.to_a
  end
  
  define_method :"test select by :left_of" do
    nodes = build('1 + (2 + (3 + 4))')
    right = nodes.select(Ruby::Integer, :value => 3).first
    nodes = nodes.select(Ruby::Integer, :left_of => right)
    assert_equal 2, nodes.size
    assert_equal [Ruby::Integer], nodes.map(&:class).uniq
    assert_equal ['1', '2'], nodes.map(&:token)
  end
  
  define_method :"test select by :right_of" do
    nodes = build('1 + (2 + (3 + 4))')
    right = nodes.select(Ruby::Integer, :value => 3).first
    nodes = nodes.select(Ruby::Integer, :right_of => right)
    assert_equal 1, nodes.size
    assert_equal [Ruby::Integer], nodes.map(&:class).uniq
    assert_equal ['4'], nodes.map(&:token)
  end
end