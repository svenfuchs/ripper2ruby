require File.dirname(__FILE__) + '/../test_helper'

class RipperRubyBuilderBlockTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  @@space = "  \n  "

  define_method :"test keyword: nil" do
    src = @@space + 'nil'
    keyword = node(src, Ruby::Keyword)

    assert_equal Ruby::Keyword, keyword.class
    assert_equal nil, keyword.value
  
    assert keyword.root.is_a?(Ruby::Program)
    assert_equal src, keyword.root.src
  
    assert_equal 'nil', keyword.to_ruby
  
    assert_equal [1, 2], keyword.position
    assert_equal 1, keyword.row
    assert_equal 2, keyword.column
    assert_equal 3, keyword.length
  end
  
  define_method :"test keyword: true" do
    src = @@space + 'true'
    keyword = node(src, Ruby::Keyword)
  
    assert_equal Ruby::Keyword, keyword.class
    assert_equal true, keyword.value
  
    assert keyword.root.is_a?(Ruby::Program)
    assert_equal src, keyword.root.src
  
    assert_equal 'true', keyword.to_ruby
  
    assert_equal [1, 2], keyword.position
    assert_equal 1, keyword.row
    assert_equal 2, keyword.column
    assert_equal 4, keyword.length
  end
  
  define_method :"test keyword: false" do
    src = @@space + 'false'
    keyword = node(src, Ruby::Keyword)
  
    assert_equal Ruby::Keyword, keyword.class
    assert_equal false, keyword.value
  
    assert keyword.root.is_a?(Ruby::Program)
    assert_equal src, keyword.root.src
  
    assert_equal 'false', keyword.to_ruby
  
    assert_equal [1, 2], keyword.position
    assert_equal 1, keyword.row
    assert_equal 2, keyword.column
    assert_equal 5, keyword.length
  end
  
  define_method :"test keyword: __FILE__" do
    src = @@space + '__FILE__'
    keyword = node(src, Ruby::Keyword)
  
    assert_equal Ruby::Keyword, keyword.class
    assert_equal '__FILE__', keyword.value
  
    assert keyword.root.is_a?(Ruby::Program)
    assert_equal src, keyword.root.src
  
    assert_equal '__FILE__', keyword.to_ruby
  
    assert_equal [1, 2], keyword.position
    assert_equal 1, keyword.row
    assert_equal 2, keyword.column
    assert_equal 8, keyword.length
  end
  
  define_method :"test keyword: __LINE__" do
    src = @@space + '__LINE__'
    keyword = node(src, Ruby::Keyword)
  
    assert_equal Ruby::Keyword, keyword.class
    assert_equal '__LINE__', keyword.value
  
    assert keyword.root.is_a?(Ruby::Program)
    assert_equal src, keyword.root.src
  
    assert_equal '__LINE__', keyword.to_ruby
  
    assert_equal [1, 2], keyword.position
    assert_equal 1, keyword.row
    assert_equal 2, keyword.column
    assert_equal 8, keyword.length
  end
end