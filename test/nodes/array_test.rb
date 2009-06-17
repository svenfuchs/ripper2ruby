require File.dirname(__FILE__) + '/../test_helper'

class ArrayTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test an array: [:foo, :bar]' do
    src = '[:foo, :bar]'
    array = build(src).first
  
    assert_equal Ruby::Array, array.class
    assert_equal [:foo, :bar], array.value
    assert_equal src, array.to_ruby
    assert_equal src, array.src
  end
  
  define_method :'test a wordlist array %w(foo bar)' do
    src = '%w(foo bar)'
    array = build(src).first
  
    assert_equal Ruby::Array, array.class
    assert_equal %w(foo bar), array.value
    assert_equal src, array.to_ruby
    assert_equal src, array.src
  end
  
  define_method :"test array access" do
    src = "foo[1]"
    call = build(src).first
  
    assert_equal Ruby::Call, call.class
    assert_equal src, call.to_ruby
    assert_equal src, call.src
  end
  
  define_method :"test array assignment" do
    src = "result[0] = :value"
    assignment = build(src).first
    
    assert_equal Ruby::Assignment, assignment.class
    assert_equal src, assignment.to_ruby
    assert_equal src, assignment.src
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
      array = build(line).first
      assert_equal line, array.to_ruby
      assert_equal line.length, array.length
    end
  end
end