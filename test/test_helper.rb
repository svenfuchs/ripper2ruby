$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'ripper/ruby_builder'
require 'ripper/event_log'
require 'test/unit'
require 'pp'
require 'highlighters/ansi'

module TestHelper
  def build(src, filename = nil)
    Ripper::RubyBuilder.build(src, filename)
  end

  def sexp(src)
    pp Ripper::SexpBuilder.new(src).parse
  end

	def log(src)
	  Ripper::EventLog.out(src)
  end

  def assert_build(src)
    expr = build(src)
    assert_equal src, expr.to_ruby(true)
    assert_equal src, expr.src(true)
    #   expr.all_nodes.each { |node| assert_equal Ruby::Program, node.root.class }
    yield(expr) if block_given?
    expr
  end

  def assert_node(node, assertions)
    node = node.first if node.is_a?(Array)
    assertions.each do |type, value|
      case type
      when :is_a
        assert node.is_a?(value)
      when :class
        assert_equal value, node.class
      when :pos, :position
        assert_position(value, node)
      end
    end
  end

  def assert_position(position, node)
    node = node.first if node.is_a?(Array)
    assert_equal position, node.position.to_a
  end
end



