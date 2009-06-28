$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'pp'
require 'ripper/ruby_builder'
require 'ripper/event_log'
require 'highlighters/ansi'
require 'erb/stripper'
require 'diff/lcs'
require 'diff/lcs/hunk'

module LibTestHelper
  def build(src, filename = nil)
    Ripper::RubyBuilder.build(src, filename)
  end
	
  def sexp(src)
    pp Ripper::SexpBuilder.new(src).parse
  end

	def log(src)
	  Ripper::EventLog.out(src)
  end
  
  def filenames(root)
    Dir["#{root}/**/*.rb"].sort
  end

  def read_file(filename)
    src = File.read(filename)
    src = File.open(filename, 'r:iso-8859-1') { |f| f.read } unless src.valid_encoding?
    src = File.open(filename, 'r:ascii-8bit') { |f| f.read } unless src.valid_encoding?
    src || ''
  end

  def read_src(filename, lib = nil)
    src = read_file(filename)
    src = strip_erb(src) if lib && erb?(lib, filename)
    src || ''
  end

  def excluded?(lib, filename)
    lib[:exclude].any? { |exclude| filename.index(exclude) }
  end

  def erb?(lib, filename)
    Array(lib[:erb] || %r(/templates/|environment\.rb)).any? { |pattern| filename =~ pattern }
  end

  def strip_erb(src)
    Erb::Stripper.new.to_ruby(src)
  end

  def report(errors, name, path)
    errors = errors[name]
    msg = if errors && !errors.empty?
      # output the broken line
      # suggest possible fixes
      "#{errors.count} problems found in #{name}:\n" + errors.map { |e| e.gsub(path, name.to_s) }.join
    else
      "no problems found in #{name}"
    end
    puts msg
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