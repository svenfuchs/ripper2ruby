require File.dirname(__FILE__) + '/../test_helper'

class LiteralsTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test an integer" do
    src = '1'
    assert_build(src) do |node|
      assert_equal Ruby::Integer, node.first.class
    end
  end

  define_method :"test a float" do
    src = '1.1'
    assert_build(src) do |node|
      assert_equal Ruby::Float, node.first.class
    end
  end

  define_method :"test nil" do
    src = 'nil'
    assert_build(src) do |node|
      assert_equal Ruby::Nil, node.first.class
    end
  end

  define_method :"test true" do
    src = 'true'
    assert_build(src) do |node|
      assert_equal Ruby::True, node.first.class
    end
  end

  define_method :"test false" do
    src = 'false'
    assert_build(src) do |node|
      assert_equal Ruby::False, node.first.class
    end
  end

  define_method :"test range (..)" do
    src = '1..2'
    assert_build(src) do |node|
      assert_equal Ruby::Range, node.first.class
    end
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