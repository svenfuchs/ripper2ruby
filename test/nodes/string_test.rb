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
  
  define_method :"test a double-quoted string with an embedded expression" do
    src = '"foo#{bar}"'
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test a percent-parentheses delimited string with an embedded expression" do
    src = '%(foo #{bar})'
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test a percent-parentheses delimited string after a word-list" do
    src = "%w(a)\n%(b)"
    assert_equal src, build(src).to_ruby
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
  
  define_method :'test string concat' do
    src = "'a' 'b'"
    array = build(src).first
    assert_equal src, array.to_ruby
    assert_equal src, array.src
  end
  
  define_method :"test an empty heredoc" do
    src = "\n<<-eos\neos\n"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test a heredoc" do
    src = "<<-eos\nfoo\neos"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test a heredoc with a semicolon" do
    src = "\n<<-end;\nfoo\nend\n"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test a quoted heredoc with extra whitespace and a semicolon" do
    src = "\n<<-'end'   ;\n  foo\nend\nfoo;"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test a heredoc with an embedded expression" do
    src = "<<-eos\n  foo \#{bar} baz\neos"
    builder = Ripper::RubyBuilder.new(src)
    assert_equal src, builder.parse.to_ruby
  end
  
  define_method :"test a heredoc with an embedded array access" do
    src = "<<-end\n\#{a['b']}\nend"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test method call with heredoc" do
    src = "foo(<<-eos)\n  foo\neos"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test method call with heredoc (2)" do
    src = "foo(<<-eos\n  foo\neos\n)"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test method call with heredoc with arguments" do
    src = "foo(<<-eos, __FILE__, __LINE__)\n  foo\neos"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test method call with heredoc with arguments / operator" do
    src = "foo(<<-eos, __FILE__, __LINE__ + 1)\n  foo\neos"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test method call with heredoc with arguments / call" do
    src = "foo(<<-eos, __FILE__, line)\n  foo\neos"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test method call with heredoc with a string arg with an embedded expression" do
    src = "foo(<<-eos, \"\#{bar}\")\n  foo\neos"
    assert_equal src, build(src).to_ruby
  end
  
  define_method :"test a begin block with a heredoc" do
    src = "begin <<-src \n\n\nfoo\nsrc\n end"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test a do block with a heredoc and an embedded expression" do
    src = "each do\n <<-src \n\nfoo\n\#{bar}\nsrc\n end\n"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test heredoc with a nested embedded expression" do
    src = "<<-eos\n  \#{\"\n    \#{sym}\n  \"}\neos"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test heredoc with a multiline embedded expression" do
    src = "<<-eos\n \t\#{ a\n  }\neos"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test a heredoc with a comment on the first line" do
    src = "<<-eos # comment\neos\nfoo\nfoo\n"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test a heredoc with a comment on the first line, followed by a single-quoted string" do
    src = "<<-eos # comment\nstring\neos\n'index'"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test command_call w/ a heredoc with an if modifier on heredoc_beg" do
    src = "foo <<-eos if bar\na\neos\nbaz"
    assert_equal src, build(src).to_ruby(true)
  end
  
  define_method :"test a heredoc with a method call on the heredoc_beg token" do
    src = "<<-eos.foo\neos\nbar\n"
    assert_equal src, build(src).to_ruby(true)
  end
  

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