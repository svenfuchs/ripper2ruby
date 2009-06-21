require File.dirname(__FILE__) + '/../test_helper'

class StringTest < Test::Unit::TestCase
  include TestHelper

  # define_method :"test an empty string" do
  #   src = '""'
  #   string = build(src).first
  #   assert string.is_a?(Ruby::String)
  #   assert_equal "", string.value
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a double quoted string" do
  #   src = '"foo"'
  #   string = build(src).first
  #   assert string.is_a?(Ruby::String)
  #   assert_equal "foo", string.value
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a single quoted string" do
  #   src = "'foo'"
  #   string = build(src).first
  #   assert string.is_a?(Ruby::String)
  #   assert_equal "foo", string.value
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a percent-parens delimited string" do
  #   src = "%(foo)"
  #   string = build(src).first
  #   assert string.is_a?(Ruby::String)
  #   assert_equal "foo", string.value
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a percent-dot delimited string" do
  #   src = "%.foo."
  #   string = build(src).first
  #   assert string.is_a?(Ruby::String)
  #   assert_equal "foo", string.value
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a percent-pipe delimited string" do
  #   src = "%|foo|"
  #   string = build(src).first
  #   assert string.is_a?(Ruby::String)
  #   assert_equal "foo", string.value
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a double-quoted string with an embedded expression" do
  #   src = '"foo#{bar}"'
  #   assert_equal src, build(src).to_ruby
  # end
  # 
  # define_method :"test a percent-parentheses delimited string with an embedded expression" do
  #   src = '%(foo #{bar})'
  #   assert_equal src, build(src).to_ruby
  # end
  # 
  # define_method :"test a percent-parentheses delimited string after a word-list" do
  #   src = "%w(a)\n%(b)"
  #   assert_equal src, build(src).to_ruby
  # end
  # 
  # define_method :"test a backtick delimited string" do
  #   src = "`foo`"
  #   string = build(src).first
  #   assert string.is_a?(Ruby::ExecutableString)
  #   assert_equal "foo", string.value
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a percent-x delimited string" do
  #   src = "%x(foo)"
  #   string = build(src).first
  #   assert string.is_a?(Ruby::ExecutableString)
  #   assert_equal "foo", string.value
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a slash delimited regexp" do
  #   src = "/foo/"
  #   string = build(src).first
  #   assert string.is_a?(Ruby::Regexp)
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a percent-r delimited regexp" do
  #   src = "%r(foo)"
  #   string = build(src).first
  #   assert string.is_a?(Ruby::Regexp)
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a string with a backreference" do
  #   src = '"#{$1}"'
  #   string = build(src).first
  #   assert string.is_a?(Ruby::String)
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :"test a string with a dvar" do
  #   src = '"#$0"'
  #   string = build(src).first
  #   assert string.is_a?(Ruby::String)
  #   assert_equal src, string.to_ruby
  # end
  # 
  # define_method :'test string concat' do
  #   src = "'a' 'b'"
  #   array = build(src).first
  #   assert_equal src, array.to_ruby
  #   assert_equal src, array.src
  # end
  
  # define_method :"test a heredoc" do
  #   src = "<<-eos\nfoo\neos"
  #   assert_equal src, build(src).to_ruby
  # end
  # 
  # define_method :"test a heredoc with a semicolon" do
  #   src = "\n<<-end;\nfoo\nend\n"
  #   assert_equal src, build(src).to_ruby(true)
  # end
  # 
  # define_method :"test an empty heredoc" do
  #   src = "\n<<-end\nend\n"
  #   assert_equal src, build(src).to_ruby(true)
  # end
  # 
  # define_method :"test a quoted heredoc with extra whitespace and a semicolon" do
  #   src = "\n<<-'end'   ;\n  foo\nend\nfoo;"
  #   assert_equal src, build(src).to_ruby(true)
  # end
  # 
  # define_method :"test a heredoc with an embedded expression" do
  #   src = "<<-eos\n  foo \#{bar} baz\neos"
  #   assert_equal src, build(src).to_ruby
  # end
  
  define_method :"test a heredoc with an embedded array access" do
    src = "<<-end\n\#{a['b']}\nend"
    pp sexp(src)
    assert_equal src, build(src).to_ruby
  end
  
  # define_method :"test method call with heredoc" do
  #   src = "foo(<<-eos)\n  foo\neos"
  #   call = build(src)
  #   assert_equal src, call.to_ruby
  # end
  # 
  # define_method :"test method call with heredoc (2)" do
  #   src = "foo(<<-eos\n  foo\neos\n)"
  #   assert_equal src, build(src).to_ruby
  # end
  # 
  # define_method :"test method call with heredoc with arguments" do
  #   src = "foo(<<-eos, __FILE__, __LINE__ + 1)\n  foo\neos"
  #   assert_equal src, build(src).to_ruby
  # end
  # 
  # define_method :"test a block with a heredoc (no trailing whitespace)" do
  #   src = "begin <<-src \n\n\nfoo\nsrc\n end"
  #   assert_equal src, build(src).to_ruby(true)
  # end
  
# foo <<-eoc, __FILE__, __LINE__ + 1
# eoc
  
  
  # Ripper doesn't seem to recognize stacked heredocs. Only one on_heredoc_beg etc event is triggered.

  # define_method :"test a stacked quoted heredoc" do
  #   src = '
  #     <<-"foo", <<-"bar"
  #       I said foo.
  #     foo
  #       I said bar.
  #     bar
  #   '
  #   pp sexp(src)
  #   assert_equal src, build(src).to_ruby(true)
  # end
end