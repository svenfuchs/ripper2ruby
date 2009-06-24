require File.dirname(__FILE__) + '/../test_helper'
require 'ruby/node/text'

class TextClipTest < Test::Unit::TestCase
  include Ruby

  def setup
    @lines = Node::Text.split("abcd\nbbbb\ncccc\ndddd\neeee\nffff")
  end

  define_method :"test clip.to_s (1)" do
    assert_equal "ab", Node::Text::Clip.new(@lines, [0, 0], 2).to_s
  end

  define_method :"test clip.to_s (2)" do
    assert_equal "bc", Node::Text::Clip.new(@lines, [0, 1], 2).to_s
  end

  define_method :"test clip.to_s (3)" do
    assert_equal "cd", Node::Text::Clip.new(@lines, [0, 2], 2).to_s
  end

  define_method :"test clip.to_s (4)" do
    assert_equal "abcd\nbbbb\n", Node::Text::Clip.new(@lines, [0, 0], 10).to_s
  end

  define_method :"test clip.to_s (5)" do
    assert_equal "abcd\nbbbb\ncc", Node::Text::Clip.new(@lines, [0, 0], 12).to_s
  end

  define_method :"test clip.to_s (6)" do
    assert_equal "cc\ndddd\nee", Node::Text::Clip.new(@lines, [2, 2], 10).to_s
  end

  define_method :"test clip.head" do
    assert_equal "abcd\nbbbb\ncc", Node::Text::Clip.new(@lines, [2, 2], 10).head
  end

  define_method :"test clip.tail (1)" do
    assert_equal "b\ncccc\ndddd\neeee\nffff", Node::Text::Clip.new(@lines, [0, 2], 6).tail
  end

  define_method :"test clip.tail (2)" do
    assert_equal "fff", Node::Text::Clip.new(@lines, [4, 2], 4).tail
  end

  define_method :"test clip.end (1)" do
    assert_equal [0, 2], Node::Text::Clip.new(@lines, [0, 0], 2).end.to_a
  end

  define_method :"test clip.end (2)" do
    assert_equal [2, 0], Node::Text::Clip.new(@lines, [0, 0], 10).end.to_a
  end

  define_method :"test clip.end (3)" do
    assert_equal [3, 2], Node::Text::Clip.new(@lines, [1, 2], 10).end.to_a
  end

  define_method :"test clip.end (4)" do
    assert_equal [5, 1], Node::Text::Clip.new(@lines, [4, 2], 4).end.to_a
  end
end

class TextTest < Test::Unit::TestCase
  include Ruby

  def setup
    @text = Node::Text.new("aa\nbb\ncc\ndd\nee\nff")
  end

  define_method :"test lines returns an array of lines" do
    assert_equal ::Array, @text.lines.class
    assert_equal 6, @text.lines.size
  end

  define_method :"test clip returns a clip" do
    assert_equal Node::Text::Clip, @text.clip([1, 1], 6).class
    assert_equal "b\ncc\nd", @text.clip([1, 1], 6).to_s
  end
end

class TextNodeTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test nodes yield expected src clips" do
    src = " t(1, 2)\n t(3); t(4)\n t(5)"
    calls = build(src)
  
    assert_equal 't(1, 2)', calls[0].to_ruby
    assert_equal 't(1, 2)', calls[0].src
  
    assert_equal 't(3)', calls[1].to_ruby
    assert_equal 't(3)', calls[1].src
  
    assert_equal 't(4)', calls[2].to_ruby
    assert_equal 't(4)', calls[2].src
  
    assert_equal 't(5)', calls[3].to_ruby
    assert_equal 't(5)', calls[3].src
  end

  define_method :"test nodes yield expected src clips, including whitespace" do
    src = " t(1, 2)\n t(3); t(4)\n t(5)"
    calls = build(src)

    assert_equal " t(1, 2)", calls[0].to_ruby(true)
    assert_equal " t(1, 2)", calls[0].src(true)
    
    assert_equal "\n t(3)", calls[1].to_ruby(true)
    assert_equal "\n t(3)", calls[1].src(true)
    
    assert_equal "; t(4)", calls[2].to_ruby(true)
    assert_equal "; t(4)", calls[2].src(true)
    
    assert_equal "\n t(5)", calls[3].to_ruby(true)
    assert_equal "\n t(5)", calls[3].src(true)
  end
end