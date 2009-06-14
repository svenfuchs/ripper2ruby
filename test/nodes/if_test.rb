require File.dirname(__FILE__) + '/../test_helper'

class RipperToRubyIfTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :'test if block, semicolon separated' do
    src = "if true; false end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test if block, newline separated' do
    src = "if true\n false end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test if block w/ then, not separated' do
    src = "if true then false end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test if block w/ else block, semicolon separated' do
    src = "if true; false; else; true end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test if block w/ else block, newline separated' do
    src = "if true\n false\n else\n true end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test if block w/ elsif block, semicolon separated' do
    src = "if true; false; elsif false; true end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test if block w/ elsif block, newline separated' do
    src = "if true\n false\n elsif false\n true end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test if block w/ then, else block and elsif block, semicolon separated' do
    src = "if true then false; elsif false then true; else nil end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test if block w/ then, else block and elsif block, newline separated' do
    src = "if a == 1 then b\nelsif b == c then d\ne\nf\nelse e end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test if modifier' do
    src = "foo if true"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
end

class RipperToRubyControlUnlessTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :'test unless block, semicolon separated' do
    src = "unless true; false end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test unless block, newline separated' do
    src = "unless true\n false end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test unless block w/ then, not separated' do
    src = "unless true then false end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test unless block w/ else block, semicolon separated' do
    src = "unless true; false; else; true end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test unless block w/ else block, newline separated' do
    src = "unless true\n false\n else\n true end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test unless modifier' do
    src = "foo unless true"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
end