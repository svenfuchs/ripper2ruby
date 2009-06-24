$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'pp'
require 'ripper/ruby_builder'
require 'highlighters/ansi'
require 'erb/stripper'
require 'diff/lcs'
require 'diff/lcs/hunk'


module LibTestHelper
  def filenames(root)
    Dir["#{root}/**/*.rb"].sort
  end

  def read_file(filename)
    src = File.read(filename)
    src = File.open(filename, 'r:iso-8859-1') { |f| f.read } unless src.valid_encoding?
    src || ''
  end

  def read_src(filename, lib = nil)
    src = read_file(filename)
    src = strip_erb(src) if lib && erb?(lib, filename)
    src = src.split(/^__END__$/).first
    src || ''
  end

  def excluded?(lib, filename)
    Array(lib[:exclude]).any? { |exclude| filename.index(exclude) }
  end

  def erb?(lib, filename)
    Array(lib[:erb]).any? { |pattern| filename =~ pattern }
  end

  def strip_erb(src)
    Erb::Stripper.new.to_ruby(src)
  end

  def report(errors)
    errors.each do |name, errors|
      puts "\n\n"
      puts errors.empty? ? 
        "no problems found in #{name}" :
        "#{errors.count} problems found in #{name}:\n" + errors.join
    end
  end
end