require File.dirname(__FILE__) + '/../test_helper'

class StringTest < Test::Unit::TestCase
  include TestHelper
  
  def assert_string(src, value = nil, klass = Ruby::String)
    assert_build(src) do |node|
      assert_equal klass, node.first.class
      assert_equal value, node.first.value if value
    end
  end

  define_method :"test an empty string" do
    src = '""'
    assert_string(src, '')
  end
  
  define_method :"test a double quoted string" do
    src = '"foo"'
    assert_string(src, 'foo')
  end
  
  define_method :"test a single quoted string" do
    src = "'foo'"
    assert_string(src, 'foo')
  end
  
  define_method :"test a percent-parens delimited string" do
    src = "%(foo)"
    assert_string(src, 'foo')
  end
  
  define_method :"test a percent-dot delimited string" do
    src = "%.foo."
    assert_string(src, 'foo')
  end
  
  define_method :"test a percent-pipe delimited string" do
    src = "%|foo|"
    assert_string(src, 'foo')
  end
  
  define_method :"test a double-quoted string with an embedded expression" do
    src = '"foo#{bar}"'
    assert_string(src)
  end
  
  define_method :"test a percent-parentheses delimited string with an embedded expression" do
    src = '%(foo #{bar})'
    assert_string(src)
  end
  
  define_method :"test a percent-parentheses delimited string after a word-list" do
    src = "%w(a)\n%(b)"
    assert_build(src)
  end
  
  define_method :"test a backtick delimited string" do
    src = "`foo`"
    assert_build(src)
  end
  
  define_method :"test a percent-x delimited string" do
    src = "%x(foo)"
    assert_build(src)
  end
  
  define_method :"test a slash delimited regexp" do
    src = "/foo/"
    assert_build(src)
  end
  
  define_method :"test a percent-r delimited regexp" do
    src = "%r(foo)"
    assert_build(src)
  end
  
  define_method :"test a string with a backreference" do
    src = '"#{$1}"'
    assert_build(src)
  end
  
  define_method :"test a string with a dvar" do
    src = '"#$0"'
    assert_build(src)
  end
  
  define_method :'test string concat' do
    src = "'a' 'b'"
    assert_build(src)
  end
end