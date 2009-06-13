require File.dirname(__FILE__) + '/../test_helper'

class RipperRubyBuilderBlockTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :"test a block with arguments" do
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

  define_method :"test an empty brace_block" do
    src = "{ |(a, b), *c| }"
    block = call('t' + src).block
    assert_equal src, block.to_ruby
  end

  define_method :"test an empty do_block" do
    src = "do |(a, b), *c| end"
    block = call('t ' + src).block
    assert_equal src, block.to_ruby
  end
end