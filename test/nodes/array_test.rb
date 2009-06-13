require File.dirname(__FILE__) + '/../test_helper'

class RipperToRubyArrayTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :'test an array: [:foo, :bar]' do
    src = '[:foo, :bar]'
    array = array(src)

    assert_equal Ruby::Array, array.class
    assert_equal :foo, array.first.value

    assert array.root.is_a?(Ruby::Program)
    assert_equal array, array.first.parent

    assert_equal src, array.root.src
    assert_equal src, array.first.root.src
    assert_equal src, array.to_ruby

    assert_equal [0, 0], array.position
    assert_equal 0, array.row
    assert_equal 0, array.column

    assert_equal [0, 1], array[0].position
    assert_equal 0, array[0].row
    assert_equal 1, array[0].column

    assert_equal [0, 7], array[1].position
    assert_equal 0, array[1].row
    assert_equal 7, array[1].column
  end

  define_method :'test a wordlist array %w(foo bar)' do
    src = '%w(foo bar)'
    array = array(src)

    assert_equal Ruby::Array, array.class
    assert_equal 'foo', array[0].value
    assert_equal 'bar', array[1].value

    assert array.root.is_a?(Ruby::Program)
    assert_equal array, array.first.parent

    assert_equal src, array.root.src
    assert_equal src, array.first.root.src
    assert_equal src, array.to_ruby

    assert_equal [0, 0], array.position
    assert_equal 0, array.row
    assert_equal 0, array.column
    assert_equal 11, array.length
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
      assert_equal line, array(line).to_ruby
      assert_equal line.length, array(line).length
    end
  end
  
  define_method :"test array assignment" do
    src = "result[0] = :value"
    assignment = node(src, Ruby::Assignment)
    assert_equal Ruby::Assignment, assignment.class
    assert_equal src, assignment.to_ruby
  end
end