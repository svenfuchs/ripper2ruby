require File.dirname(__FILE__) + '/../test_helper'

class BlockTest < Test::Unit::TestCase
  include TestHelper
  
  define_method :"test a block with an invalid param" do
    src = 'foo { |@a| }'
    assert_raises(Ripper::RubyBuilder::ParseError) { build(src) }
  end
  
  define_method :"test method call block with 2 statements (newline delimited)" do
    src = "t do\nfoo\nbar\nend"
    assert_build(src)
  end
  
  define_method :"test method call block with no statements, single semicolon" do
    src = "t do ; end"
    assert_build(src)
  end
  
  define_method :"test method call block with empty params" do
    src = "t do ||\nfoo\n end"
    assert_build(src)
  end
  
  define_method :"test method call block with semicolon delimited statements" do
    src = "t do ;; ;foo ; ;;bar; ; end"
    assert_build(src)
  end
  
  define_method :"test: a method call block with arguments" do
    src = "t do |(a, b), *c|\n        foo\n        bar\n      end"
    assert_build(src)
  end
  
  define_method :"test: an empty method call brace_block" do
    src = "t { |(a, b), *c| }"
    assert_build(src)
  end
  
  define_method :"test: method call w/ do_block" do
    src = "t do |(a, b), *c| end"
    assert_build(src)
  end
  
  define_method :"test: method call do_block with a block_param" do
    src = "t do |*a, &c| end"
    assert_build(src)
  end
  
  define_method :"test: an empty method call brace_block w/ arg and parenthesed param" do
    src = 't {|a, (b)| }'
    assert_build(src)
  end
  
  define_method :"test: an empty begin end block" do
    src = "begin\nend"
    assert_build(src)
  end
  
  define_method :"test: a begin ; end block" do
    src = "begin ; end"
    assert_build(src)
  end
  
  define_method :"test: a begin foo; end block" do
    src = "begin foo; end"
    assert_build(src)
  end
  
  define_method :"test: a begin block with an else block" do
    src = "begin\nfoo\nelse\nbar\nend"
    assert_build(src)
  end
  
  define_method :"test: a begin block with rescue without error_type" do
    src = "begin\nfoo\nrescue\nbar\nend"
    assert_build(src) do |code|
      assert code.select(Ruby::Assoc).empty?, "should not add an Assoc to the params list"
    end
  end
  
  define_method :"test: a begin block with rescue without an error_type" do
    src = "begin \n rescue A \n end"
    assert_build(src)
  end
  
  define_method :"test: a begin block with rescue with a error_types and error_var" do
    src = "begin foo\n rescue A => e\n bar\n end"
    assert_build(src)
  end
  
  define_method :"test: a begin block with rescue with a multiple error_types and error_var" do
    src = "begin foo\n rescue A, B => e\n bar\n end"
    assert_build(src)
  end
  
  define_method :"test: a begin block with multiple rescues and ensure" do
    src = "begin foo\n rescue A, B => e\n bar\nrescue C => e\n bam\nensure\nbaz\n end"
    assert_build(src)
  end
  
  define_method :"test: a begin block using rescue, then and else (from rubylexer tests)" do
    src = "begin a; rescue NameError => e then e else :foo end"
    assert_build(src)
  end
  
  define_method :"test: multiple rescue blocks" do
    src = "begin\nrescue A => e\nrescue B\nend"
    assert_build(src)
  end
  
  define_method :"test: rescue and else block" do
    src = "begin\nrescue A\nelse\nend\n"
    assert_build(src)
  end
  
  define_method :"test: line with a rescue modifier yielding a method call" do
    src = "foo rescue bar"
    assert_build(src)
  end
  
  define_method :"test: line with a rescue modifier yielding an integer" do
    src = "foo rescue 0"
    assert_build(src)
  end
end