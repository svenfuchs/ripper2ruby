require File.dirname(__FILE__) + '/../test_helper'

# BEGIN { ... }
# END { ... }

class RipperToRubyRoutinesTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :'test begin routine' do
    src = "BEGIN { foo }"
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
  end
end