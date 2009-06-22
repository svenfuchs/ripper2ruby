require File.dirname(__FILE__) + '/../test_helper'

# for i in 1..5; ...; end

class ForTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test for loop, semicolon separated' do
    src = "for i in [1]; a; end"
    expr = build(src)
    assert_equal src, expr.to_ruby
    assert_equal src, expr.src
  end
  
  define_method :'test for loop, newline separated' do
    src = "for i in [1]\n a\n end"
    expr = build(src)
    assert_equal src, expr.to_ruby
    assert_equal src, expr.src
  end
  
  define_method :'test for loop, do block' do
    src = "for i in [1] do a\n end"
    expr = build(src)
    assert_equal src, expr.to_ruby
    assert_equal src, expr.src
  end
  
  define_method :'test for loop contained in a do block' do
    src = "lambda do\n  for a in b\n  end\nend"
    expr = build(src)
    assert_equal src, expr.to_ruby
    assert_equal src, expr.src
  end
  
  define_method :'test nested for loop, newline separated' do
    src = "\nfor i in 0...1 do\n  for j in 0...2 do\n  end\nend\n"
    expr = build(src)
    assert_equal src, expr.to_ruby
    assert_equal src, expr.src
  end
end