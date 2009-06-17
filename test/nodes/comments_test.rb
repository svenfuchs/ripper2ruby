require File.dirname(__FILE__) + '/../test_helper'

class CommentsTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test a variable with a preceeding 3-line comment" do
    src = "# 1\n# 2\n# 3\na"
    assert_equal src, build(src).to_ruby(true)
  end

  define_method :"test a variable with a succeeding comment" do
    src = "a # 1"
    assert_equal src, build(src).to_ruby(true)
  end

  define_method :"test a block with a variable with a succeeding comment" do
    src = "begin\n  a # 1 \nend"
    assert_equal src, build(src).to_ruby(true)
  end

  define_method :"test a method definition with a variable with a succeeding comment" do
    src = "def foo(a = 1)\n  a # 1 \nend"
    assert_equal src, build(src).to_ruby(true)
  end
end