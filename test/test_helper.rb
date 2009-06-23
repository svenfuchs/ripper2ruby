$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

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
	
	def log(src)
	  puts '', src
	  puts '', LogSexpBuilder.events(src), ''
  end
  
  def assert_compiles_to_original(src)
    expr = build(src).statements.first
    assert_equal src, expr.to_ruby
    assert_equal src, expr.src
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
	      hunk = Diff::LCS::Hunk.new(data_old, data_new, piece, context_lines,
	                                 file_length_difference)
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
	end
end

class LogSexpBuilder < Ripper::SexpBuilder
  @@events = []
  
  class << self
    def events(src)
      new(src).parse
      @@events.join("\n")
    end
  end
  
  { 'scanner' => SCANNER_EVENTS, 'parser' => PARSER_EVENTS }.each do |type, events|
    events.each do |event|
      define_method :"on_#{event}" do |*args|
        event = super(*args).first

        arg = args.first =~ /\s/ ? args.first.inspect : args.first
        line = (event.to_s).ljust(20)
        line += arg[0..30] if type == 'scanner'
        @@events << line
        ')'
      end
    end
  end
end


