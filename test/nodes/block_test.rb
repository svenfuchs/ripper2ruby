require File.dirname(__FILE__) + '/../test_helper'

class BlockTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test method call block with 2 statements (newline delimited)" do
    src = "t do\nfoo\nbar\nend"
    call = build(src).first
  
    assert_equal Ruby::Block, call.block.class
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test method call block with no statements, single semicolon" do
    src = "t do ; end"
    call = build(src).first
  
    assert_equal Ruby::Block, call.block.class
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test method call block with semicolon delimited statements" do
    src = "t do ;; ;foo ; ;;bar; ; end"
    call = build(src).first
  
    assert_equal Ruby::Block, call.block.class
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test: a method call block with arguments" do
    src = "t do |(a, b), *c|\n        foo\n        bar\n      end"
    call = build(src).first
    
    assert_equal Ruby::Block, call.block.class
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test: an empty method call brace_block" do
    src = "t { |(a, b), *c| }"
    call = build(src).first
    
    assert_equal Ruby::Block, call.block.class
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test: an empty method call do_block" do
    src = "t do |(a, b), *c| end"
    call = build(src).first
    
    assert_equal Ruby::Block, call.block.class
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test: an empty begin end block" do
    src = "begin\nend"
    block = build(src).first
    assert_equal src, block.to_ruby
  end
  
  define_method :"test: a begin ; end block" do
    src = "begin ; end"
    block = build(src).first
    assert_equal src, block.to_ruby
  end
  
  define_method :"test: a begin foo; end block" do
    src = "begin foo; end"
    block = build(src).first
    assert_equal src, block.to_ruby
  end
  
  define_method :"test: a begin block with rescue" do
    src = "begin foo\n rescue A, B => e\n bar\n end"
    block = build(src).first
    assert_equal src, block.to_ruby
  end
  
  define_method :"test: a begin block with multiple rescues and ensure" do
    src = "begin foo\n rescue A, B => e\n bar\nrescue C => e\n bam\nensure\nbaz\n end"
    block = build(src).first
    assert_equal src, block.to_ruby
  end
end