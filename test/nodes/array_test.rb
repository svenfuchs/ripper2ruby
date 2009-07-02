require File.dirname(__FILE__) + '/../test_helper'

class ArrayTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test an array: [:foo, :bar]' do
    src = '[:foo, :bar]'
    assert_build(src) do |node|
      assert_node node.first, :class => Ruby::Array, :value => [:foo, :bar]
      assert_position [0, 1], node.select(:value => :foo)
      assert_position [0, 7], node.select(:value => :bar)
    end
  end
  
  define_method :'test a wordlist array %w(foo bar) (parentheses)' do
    src = '%w(foo bar)'
    assert_build(src) do |node|
      assert_node node.first, :class => Ruby::Array, :value => %w(foo bar)
      assert_position [0, 3], node.first.select(:value => 'foo')
      assert_position [0, 7], node.select(:value => 'bar')
    end
  end
  
  define_method :"test a percent-parens delimited string" do
    src = "%(foo)"
    assert_build(src)
  end
  
  define_method :'test a multiline wordlist array %w(\nfoo bar\n)' do
    src = "%w(\nfoo bar\n).foo"
    assert_build(src)
  end
  
  define_method :'test a multiline wordlist array w/ extra whitespace %w( \nfoo bar\n )' do
    src = "%w( \nfoo bar\n ).foo"
    assert_build(src)
  end
  
  define_method :'test a wordlist array %W[foo bar] (brackets)' do
    src = '%W[foo bar]'
    assert_build(src)
  end
  
  define_method :'test an empty wordlist (using parentheses)' do
    src = "%w()"
    assert_build(src)
  end
  
  define_method :'test an empty wordlist (interpolating, using parentheses)' do
    src = "%W()"
    assert_build(src)
  end
  
  define_method :'test an empty wordlist (using brackets)' do
    src = "%w[]"
    assert_build(src)
  end
  
  define_method :'test an empty wordlist (interpolating, using brackets)' do
    src = "%W[]"
    assert_build(src)
  end
  
  define_method :'test a wordlist with an embedded expression (using brackets)' do
    src = "%W[\#{foo}]"
    assert_build(src) do |node|
      assert_position [0, 3], node.select(:class => Ruby::Statements)
      assert_position [0, 5], node.select(:token => 'foo').first
    end
  end
  
  define_method :"test array access" do
    src = "foo[1]"
    assert_build(src) do |node|
      assert_position [0, 4], node.select(:value => 1).first
    end
  end
  
  define_method :"test array access with no argument" do
    src = "foo[]"
    assert_build(src)
  end
  
  define_method :"test array access on a call with no argument" do
    src = "foo.bar[]"
    assert_build(src)
  end
  
  define_method :"test array w/ nested array access" do
    src = '[ foo[bar] ]'
    assert_build(src)
  end
   
  define_method :"test array assignment" do
    src = "result[0] = :value"
    assert_build(src)
  end
  
  define_method :'test nested array with whitespace' do
    src = "\n  [type, [row]]\n" 
    assert_build(src)
  end
  
  define_method :'test array length: with and without whitespace' do
    src = <<-eoc
      [:foo]
      [:foo  ]
      [  :foo]
      [  :foo  ]
  
      [:foo]
      [:foo  ]
      [  :foo]
      [  :foo  ]
  
      [:foo,  :bar,  :baz]
      [:foo , :bar , :baz]
      [:foo  ,:bar  ,:baz]
  
      %w(foo)
      %w(foo bar)
      %w(foo  bar)
  
      %w( foo)
      %w( foo bar)
      %w( foo  bar)
  
      %w(foo )
      %w(foo bar )
      %w(foo  bar )
  
      %w( foo )
      %w( foo bar )
      %w( foo  bar )
    eoc
    
    src.split("\n").map { |l| l.strip }.select { |l| !l.empty? }.each do |line|
      assert_build(line)
    end
  end
end