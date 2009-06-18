require File.dirname(__FILE__) + '/../test_helper'

class StringTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test an empty string" do
    src = '""'
    string = build(src).first
    assert string.is_a?(Ruby::String)
    assert_equal "", string.value
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a double quoted string" do
    src = '"foo"'
    string = build(src).first
    assert string.is_a?(Ruby::String)
    assert_equal "foo", string.value
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a single quoted string" do
    src = "'foo'"
    string = build(src).first
    assert string.is_a?(Ruby::String)
    assert_equal "foo", string.value
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a percent-parens delimited string" do
    src = "%(foo)"
    string = build(src).first
    assert string.is_a?(Ruby::String)
    assert_equal "foo", string.value
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a percent-dot delimited string" do
    src = "%.foo."
    string = build(src).first
    assert string.is_a?(Ruby::String)
    assert_equal "foo", string.value
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a percent-pipe delimited string" do
    src = "%|foo|"
    string = build(src).first
    assert string.is_a?(Ruby::String)
    assert_equal "foo", string.value
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a string with an embedded expression" do
    src = '"foo#{bar}"'
    string = build(src).first
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a backtick delimited string" do
    src = "`foo`"
    string = build(src).first
    assert string.is_a?(Ruby::ExecutableString)
    assert_equal "foo", string.value
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a percent-x delimited string" do
    src = "%x(foo)"
    string = build(src).first
    assert string.is_a?(Ruby::ExecutableString)
    assert_equal "foo", string.value
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a slash delimited regexp" do
    src = "/foo/"
    string = build(src).first
    assert string.is_a?(Ruby::Regexp)
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a percent-r delimited regexp" do
    src = "%r(foo)"
    string = build(src).first
    assert string.is_a?(Ruby::Regexp)
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a string with a backreference" do
    src = '"#{$1}"'
    string = build(src).first
    assert string.is_a?(Ruby::String)
    assert_equal src, string.to_ruby
  end
  
  define_method :"test a string with a dvar" do
    src = '"#$0"'
    string = build(src).first
    assert string.is_a?(Ruby::String)
    assert_equal src, string.to_ruby
  end

  define_method :"test a heredoc string" do
    src = "<<-eos\nfoo\neos"
    string = build(src).first
    assert string.is_a?(Ruby::String)
    assert_equal src, string.to_ruby
  end
end