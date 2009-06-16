$: << File.expand_path(File.dirname(__FILE__) + '/../lib2')

require 'ripper/ruby_builder'
require 'test/unit'
require 'pp'

module TestHelper
  def sexp(src)
    Ripper::SexpBuilder.new(src).parse
  end

  def build(src)
    Ripper::RubyBuilder.build(src)
  end
  
  def assert_compiles_to_original(src)
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
    assert_equal src, expr.src
  end
end
