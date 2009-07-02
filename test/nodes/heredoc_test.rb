require File.dirname(__FILE__) + '/../test_helper'

class HeredocTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test an empty heredoc" do
    src = "\n<<-eos\neos\n"
    assert_build(src)
  end

  define_method :"test a heredoc" do
    src = "<<-eos\nfoo\neos"
    assert_build(src)
  end

  define_method :"test a heredoc and strings" do
    src = "'string'\n<<-eos\nheredoc\neos\n'string'"
    assert_build(src)
  end

  define_method :"test a heredoc and dyna symbols" do
    src = ":'symbol'\n<<-eos\nheredoc\neos\n:'symbol'"
    assert_build(src)
  end

  define_method :"test a heredoc and words" do
    src = "%w(words)\n<<-eoc\n  heredoc\neoc\n%w(words)"
    assert_build(src)
  end

  define_method :"test a heredoc and a call with words" do
    src = "foo(%w(words))\n<<-eoc\n\neoc"
    assert_build(src)
  end

  define_method :"test a heredoc with a semicolon" do
    src = "\n<<-end;\nfoo\nend\n"
    assert_build(src)
  end

  define_method :"test a quoted heredoc with extra whitespace and a semicolon" do
    src = "\n<<-'end'   ;\n  foo\nend\nfoo;"
    assert_build(src)
  end

  define_method :"test a heredoc with an embedded expression" do
    src = "<<-eos\n  foo \#{bar} baz\neos"
    assert_build(src)
  end

  define_method :"test a heredoc with an embedded array access" do
    src = "<<-end\n\#{a['b']}\nend"
    src = "<<-end\n\#{'a'}\nend"
    assert_build(src)
  end

  define_method :"test method call with heredoc" do
    src = "foo(<<-eos)\n  foo\neos"
    assert_build(src)
  end

  define_method :"test method call with heredoc (2)" do
    src = "foo(<<-eos\n  foo\neos\n)"
    assert_build(src)
  end

  define_method :"test method call with heredoc with arguments" do
    src = "foo(<<-eos, __FILE__, __LINE__)\n  foo\neos"
    assert_build(src)
  end

  define_method :"test method call with heredoc with arguments / operator" do
    src = "foo(<<-eos, __FILE__, __LINE__ + 1)\n  foo\neos"
    assert_build(src)
  end

  define_method :"test method call with heredoc with arguments / call" do
    src = "foo(<<-eos, __FILE__, line)\n  foo\neos"
    assert_build(src)
  end

  define_method :"test method call with heredoc with a string arg with an embedded expression" do
    src = "foo(<<-eos, \"\#{bar}\")\n  foo\neos"
    assert_build(src)
  end

  define_method :"test a begin block with a heredoc" do
    src = "begin <<-src \n\n\nfoo\nsrc\n end"
    assert_build(src)
  end

  define_method :"test a do block with a heredoc and an embedded expression" do
    src = "each do\n <<-src \n\nfoo\n\#{bar}\nsrc\n end\n"
    assert_build(src)
  end

  define_method :"test heredoc with a nested embedded expression" do
    src = "<<-eos\n  \#{\"\n    \#{sym}\n  \"}\neos"
    assert_build(src)
  end

  define_method :"test heredoc with a multiline embedded expression" do
    src = "<<-eos\n \t\#{ a\n  }\neos"
    assert_build(src)
  end

  define_method :"test heredoc with an embedded expression containing a dyna_symbol" do
    src = "<<-eos\n\#{:'dyna_symbol'}\neos"
    assert_build(src)
  end

  define_method :"test a heredoc with a comment on the first line" do
    src = "<<-eos # comment\neos\nfoo\nfoo\n"
    assert_build(src)
  end

  define_method :"test a heredoc with a comment on the first line, followed by a single-quoted string" do
    src = "<<-eos # comment\nstring\neos\n'index'"
    assert_build(src)
  end

  define_method :"test command_call w/ a heredoc with an if modifier on heredoc_beg" do
    src = "foo <<-eos if bar\na\neos\nbaz"
    assert_build(src)
  end

  define_method :"test a heredoc with a method call on the heredoc_beg token" do
    src = "<<-eos.foo\neos\nbar\n"
    assert_build(src)
  end

  define_method :"test a heredoc with an xstring as a heredoc_beg token" do
    src = "foo = <<-`foo`\nfoo"
    assert_build(src)
  end

  define_method :"test multiple heredocs" do
    src = "<<-end\nend\n<<-end\n\nend\n"
    assert_build(src)
  end

  define_method :"test a stacked quoted heredoc" do
    src = 'heredocs = <<-"foo", <<-"bar"
        I said foo.
      foo
        I said bar.
      bar
    '
    assert_build(src)
  end

  define_method :"test a heredoc after an empty words list" do
    src = "a = %w[]\n<<-eos\nfoo\neos"
    assert_build(src)
  end

  define_method :"test a heredoc containing an __END__ keyword" do
    src = "<<-eos\nfoo\n__END__\neos"
    assert_build(src)
  end

  define_method :"test a stuffed heredoc (from rubylexer tests)" do
    src = <<-eos
p <<stuff+'foobar'.tr('j-l','d-f') \\
+"more stuff"
12345678
the quick brown fox jumped over the lazy dog
stuff
eos
    assert_build(src)
  end

  define_method :"test a stuffed heredoc (from rubylexer tests) (2)" do
    src = <<-eos
p(<<stuff+'foobar')\\
+"more stuff"
some stuff
stuff
eos
    assert_build(src)
  end

  define_method :"test a stuffed heredoc (from rubylexer tests) (3)" do
    src = <<-eos
p <<stuff+'foobar' \\
+"more stuff"
some stuff
stuff
eos
    assert_build(src)
  end

  define_method :"test a stuffed heredoc (from rubylexer tests) (4)" do
    src = <<-eos
p <<stuff+'foobar'+
some stuff
stuff
"more stuff"
eos
    assert_build(src)
  end
end