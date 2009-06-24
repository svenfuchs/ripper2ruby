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
  
  define_method :"test method call block with empty params" do
    src = "t do ||\nfoo\n end"
    call = build(src).first
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
    src = "t do |(a)|;end"
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
  
  define_method :"test: method call w/ do_block" do
    src = "t do |(a, b), *c| end"
    call = build(src).first
    
    assert_equal Ruby::Block, call.block.class
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test: method call do_block with a block_arg" do
    src = "t do |*a, &c| end"
    call = build(src).first
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test: an empty method call brace_block w/ arg and parenthesed arg" do
    src = 't {|a, (b)| }'
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test: an empty begin end block" do
    src = "begin\nend"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test: a begin ; end block" do
    src = "begin ; end"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test: a begin foo; end block" do
    src = "begin foo; end"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test: a begin block with rescue without error_type" do
    src = "begin\nfoo\nrescue\nbar\nend"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test: a begin block with rescue without an error_type" do
    src = "begin \n rescue A \n end"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test: a begin block with rescue with a error_types and error_var" do
    src = "begin foo\n rescue A => e\n bar\n end"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test: a begin block with rescue with a multiple error_types and error_var" do
    src = "begin foo\n rescue A, B => e\n bar\n end"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test: a begin block with multiple rescues and ensure" do
    src = "begin foo\n rescue A, B => e\n bar\nrescue C => e\n bam\nensure\nbaz\n end"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test: multiple rescue blocks" do
    src = "begin\nrescue A => e\nrescue B\nend"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test: rescue and else block" do
    src = "begin\nrescue A\nelse\nend\n"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test: line with a rescue modifier yielding a method call" do
    src = "foo rescue bar"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test: line with a rescue modifier yielding an integer" do
    src = "foo rescue 0"
    assert_equal src, build(src).to_ruby
  end
end