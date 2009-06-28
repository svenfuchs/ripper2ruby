$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

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
  
  def assert_node(src)
    expr = build(src)
    assert_equal src, expr.to_ruby(true)
    assert_equal src, expr.src(true)
    yield(expr) if block_given?
  end
end



