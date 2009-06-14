require File.dirname(__FILE__) + '/../test_helper'

class RipperRubyBuilderBodyTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :"test a body is a list of statements" do
    src = "t do\nfoo\nbar\nend"
    body = call(src).block
  
    assert_equal 2, body.statements.size
    assert_equal [Ruby::Statement], body.map { |statement| statement.class }.uniq
  end

  define_method :"test an empty body with a semicolon will contain an empty statement with an rdelim" do
    src = "t do ; end"

    call = call(src)
    body = call.block

    assert_equal Ruby::Statement, body[0].class
    assert_equal ';', body[0].rdelim.token

    assert_equal src, call.to_ruby
  end

  define_method :"test a body's statements can carry a semicolon as ldelim" do
    src = "t do ; foo ; bar ; end"
    call = call(src)
    body = call.block

    assert_equal 3, body.statements.size
    assert_equal [Ruby::Statement], body.map { |statement| statement.class }.uniq
  
    assert_equal src, call.to_ruby
  end
end