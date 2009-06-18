require File.dirname(__FILE__) + '/../test_helper'

class LiteralsTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test an integer" do
    src = '1'
    literal = build(src).first
    assert literal.is_a?(Ruby::Integer)
    assert_equal 1, literal.value
    assert_equal src, literal.to_ruby
  end

  define_method :"test a float" do
    src = '1.1'
    literal = build(src).first
    assert literal.is_a?(Ruby::Float)
    assert_equal 1.1, literal.value
    assert_equal src, literal.to_ruby
  end

  define_method :"test nil" do
    src = 'nil'
    literal = build(src).first
    assert literal.is_a?(Ruby::Nil)
    assert_equal nil, literal.value
    assert_equal src, literal.to_ruby
  end

  define_method :"test true" do
    src = 'true'
    literal = build(src).first
    assert literal.is_a?(Ruby::True)
    assert_equal true, literal.value
    assert_equal src, literal.to_ruby
  end

  define_method :"test false" do
    src = 'false'
    literal = build(src).first
    assert literal.is_a?(Ruby::False)
    assert_equal false, literal.value
    assert_equal src, literal.to_ruby
  end

  define_method :"test range (..)" do
    src = '1..2'
    literal = build(src).first
    assert literal.is_a?(Ruby::Range)
    assert_equal 1..2, literal.value
    assert_equal src, literal.to_ruby
  end

  define_method :"test range (..)" do
    src = '1...2'
    literal = build(src).first
    assert literal.is_a?(Ruby::Range)
    assert_equal 1...2, literal.value
    assert_equal src, literal.to_ruby
  end

  define_method :"test character" do
    src = '?a'
    literal = build(src).first
    assert literal.is_a?(Ruby::Char)
    assert_equal 'a', literal.value
    assert_equal src, literal.to_ruby
  end
end