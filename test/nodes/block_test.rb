require File.dirname(__FILE__) + '/../test_helper'

class RipperRubyBuilderBlockTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :"test: a method call block with arguments" do
    src = <<-eoc
      t do |(a, b), *c|
        foo
        bar
      end
    eoc
    src = src.strip
    block = call(src).block
    assert_equal src, 't' + block.to_ruby(true)
  end
  
  define_method :"test: an empty method call brace_block" do
    src = "{ |(a, b), *c| }"
    block = call('t' + src).block
    assert_equal src, block.to_ruby
  end
  
  define_method :"test: an empty method call do_block" do
    src = "do |(a, b), *c| end"
    block = call('t ' + src).block
    assert_equal src, block.to_ruby
  end
  
  define_method :"test: an empty begin end block" do
    src = "begin\nend"
    block = build(src).statements.first
    assert_equal src, block.to_ruby
  end
  
  define_method :"test: a begin ; end block" do
    src = "begin ; end"
    block = build(src).statements.first
    assert_equal src, block.to_ruby
  end
  
  define_method :"test: a begin foo; end block" do
    src = "begin foo; end"
    block = build(src).statements.first
    assert_equal src, block.to_ruby
  end
  
  define_method :"test: a begin block with a rescue blocks" do
    src = "begin foo\n rescue A, B => e\n bar\n end"
    block = build(src).statements.first
    assert_equal src, block.to_ruby
  end
  
  define_method :"test: a begin block with rescue and ensure blocks" do
    src = "begin foo\n rescue A, B => e\n bar\nensure\nbaz\n end"
    block = build(src).statements.first
    assert_equal src, block.to_ruby
  end
end