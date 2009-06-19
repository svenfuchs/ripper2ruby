require File.dirname(__FILE__) + '/test_helper'
require 'ripper/text'

class TextClipTest < Test::Unit::TestCase
  def setup
    @lines = "aaaa\nbbbb\ncccc\ndddd\neeee\nffff".split("\n").map { |line| line + "\n" }
  end
  
  define_method :"test clip (1)" do
    clip = Ripper::Text::Clip.new(@lines, 2, 2, 10)
    assert_equal "cc\n", clip.head
    assert_equal "dddd\n", clip.body
    assert_equal "ee", clip.tail
    assert_equal "cc\ndddd\nee", clip.to_s
  end
  
  define_method :"test clip (2)" do
    clip = Ripper::Text::Clip.new(@lines, 0, 0, 10)
    assert_equal "aaaa\n", clip.head
    assert_equal "", clip.body
    assert_equal "bbbb\n", clip.tail
    assert_equal "aaaa\nbbbb\n", clip.to_s
  end
  
  define_method :"test clip (3)" do
    clip = Ripper::Text::Clip.new(@lines, 0, 0, 12)
    assert_equal "aaaa\n", clip.head
    assert_equal "bbbb\n", clip.body
    assert_equal "cc", clip.tail
    assert_equal "aaaa\nbbbb\ncc", clip.to_s
  end
end

class TextTest < Test::Unit::TestCase
  def setup
    @text = Ripper::Text.new("aa\nbb\ncc\ndd\nee\nff")
  end
  
  define_method :"test lines returns an array of lines" do
    assert_equal Array, @text.lines.class
    assert_equal 6, @text.lines.size
  end
  
  define_method :"test clip returns a clip" do
    assert_equal Ripper::Text::Clip, @text.clip(1, 1, 6).class
    assert_equal "b\ncc\nd", @text.clip(1, 1, 6).to_s
  end
end