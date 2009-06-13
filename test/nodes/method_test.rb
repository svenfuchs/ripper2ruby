require File.dirname(__FILE__) + '/../test_helper'

class RipperRubyBuilderMethodTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  define_method :"test a method" do
    src = <<-eoc
      def foo(a, b = nil, &block)
        bar
      end
    eoc
    src = src.strip
    method = method(src)
    bar = method.body.statements.first
  
    assert method.parent.is_a?(Ruby::Program)
    assert_equal method, method.params.parent
    assert_equal method, method.body.parent
  
    assert_equal 'foo', method.identifier.token
    assert_equal 'a', method.params.first.token
    assert_equal 'bar', bar.token
  
    assert_equal src, method.to_ruby
  end
  
  # TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO 
  
  define_method :"test method definition: def t(a = []); end" do
    src = "def t(a = []); end"
    method = build(src).statements.first
    # assert_equal 1, method.params.first
  end
  
  define_method :"test method definition: def <<()" do
    src = "def <<(arg); end"
    method = build(src).statements.first
  end
end