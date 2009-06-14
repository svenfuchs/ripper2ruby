require File.dirname(__FILE__) + '/../test_helper'

# while expression; statement; end
# begin statement end while expression
# statement while expression

class RipperToRubyWhileTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :'test while block, semicolon separated' do
    src = "while true; false end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test while block, newline separated' do
    src = "while true\n false end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test begin do while block, semicolon separated' do
    src = "begin; false; end while true"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test begin do while block, newline separated' do
    src = "begin\n false\n end while true"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
  
  define_method :'test while modifier' do
    src = "foo while true"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
end

# until expression; statement; end
# begin statement end until expression
# statement until expression

class RipperToRubyUntilTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :'test until block, semicolon separated' do
    src = "until true; false end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test until block, newline separated' do
    src = "until true\n false end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
  
  define_method :'test begin do until block, semicolon separated' do
    src = "begin; false; end until true"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test begin do until block, newline separated' do
    src = "begin\n false\n end until true"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
  
  define_method :'test until modifier' do
    src = "foo until true"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
end
