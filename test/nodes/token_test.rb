require File.dirname(__FILE__) + '/../test_helper'

class RipperToRubyTokenTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  def token(src)
    build(src).statement { |s| s.token == 'foo' }
  end

  def test_token
    src = "    \n  \n foo"
    token = token(src)

    assert_equal 'foo', token.token
    assert_equal "    \n  \n ", token.whitespace
    assert_equal [2, 1], token.position

    assert_equal 3, token.length
    assert_equal 9, token.src_pos
    assert_equal 'foo', token.src

    assert_equal 12, token.length(true)
    assert_equal 0, token.src_pos(true)
    assert_equal src, token.src(true)
  end
end