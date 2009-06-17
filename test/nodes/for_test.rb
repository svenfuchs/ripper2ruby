require File.dirname(__FILE__) + '/../test_helper'

# for i in 1..5; ...; end

class ForTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test for loop, semicolon separated' do
    src = "for i in [1]; a; end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
    assert_equal src, expr.src
  end

  define_method :'test for loop, newline separated' do
    src = "for i in [1]\n a\n end"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
    assert_equal src, expr.src
  end
end