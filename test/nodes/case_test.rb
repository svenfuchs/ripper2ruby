require File.dirname(__FILE__) + '/../test_helper'

class RipperToRubyCaseTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :'test case block, semicolon separated' do
    src = "case true; when 1; false; when 2; nil; else; nil; end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
  
  define_method :'test case block, newline separated' do
    src = "case true\n when 1\n false\n when 2\n nil\n else\n nil\n end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end

  define_method :'test case block, newline separated, using then' do
    src = "case true\n when 1 then false\n when 2 then nil\n else\n nil\n end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
end