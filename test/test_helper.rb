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
  
  def highlight_diff(str)
    green = Highlighters::Ansi.new(:green)
    red = Highlighters::Ansi.new(:red)
    str.split("\n").map do |line|
      line = green.highlight(line) if line =~ /^\+/
      line = red.highlight(line) if line =~ /^\-/
      line
    end.join("\n")
  end
  
  # some ruby cookbook
	def diff(data_old, data_new, format=:unified, context_lines=3)
  	data_old = data_old.split(/\n/).map! { |e| e.chomp }
  	data_new = data_new.split(/\n/).map! { |e| e.chomp }
	  output = ""
	  diffs = Diff::LCS.diff(data_old, data_new)
	  return output if diffs.empty?
	  oldhunk = hunk = nil
	  file_length_difference = 0
	  diffs.each do |piece|
	    begin
	      hunk = Diff::LCS::Hunk.new(data_old, data_new, piece, context_lines, file_length_difference)
	      file_length_difference = hunk.file_length_difference
	      next unless oldhunk
	      if (context_lines > 0) and hunk.overlaps?(oldhunk)
	         hunk.unshift(oldhunk)
	      else
	        output << oldhunk.diff(format)
	      end
	    ensure
	      oldhunk = hunk
	      output << "\n"
	    end
	  end
	  output << oldhunk.diff(format) << "\n"
	  highlight_diff(output)
	end
end



