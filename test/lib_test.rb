require File.dirname(__FILE__) + '/test_helper'
require 'diff/lcs'
require 'diff/lcs/hunk'
require 'erb/stripper'

LIBS = {
  :self => {
    :path => File.dirname(__FILE__) + '/../'
  },
  :rails => {
    :path => '~/Development/shared/rails/rails',
    :exclude => [],
    :erb => [
      %r(/templates|environment\.rb)
    ]
  },
  :ruby => {
    :path => '/usr/local/ruby19/lib/ruby/1.9.1',
    :exclude => [
      'cgi/html.rb',     # uses stacked heredocs
      # 'tk/namespace.rb', # uses arg_ambiguous 
      # 'tktable.rb',      # parse error
      # 'tktreectrl.rb'    # parse error
    ]
  },
  :adva_cms => {
    :path => '~/Development/projects/adva_cms/adva_cms',
    :exclude => []
  }
}


class BuildTest < Test::Unit::TestCase
  include TestHelper

  def filenames(root)
    Dir["#{root}/**/*.rb"].sort
  end

  def read_file(filename)
    src = File.read(filename)
    src = File.open(filename, 'r:iso-8859-1') { |f| f.read } unless src.valid_encoding?
    src
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

  def test_library_build
    lib = LIBS[:ruby]
    filenames(File.expand_path(lib[:path])).each do |filename|
      next if excluded?(lib, filename)
      # next if filename < '/usr/local/ruby19/lib/ruby/1.9.1/tkextlib'
      
      puts filename
      src = read_file(filename)
      src = strip_erb(src) if erb?(lib, filename)
      src = src.split(/^__END__$/).first
      
      begin
        result = build(src, filename).to_ruby(true)
        unless src == result
          puts diff(src, result)
          break
        end
        assert_equal src, result
      rescue Ripper::RubyBuilder::ParseError => e
        puts e.message
      end
    end
  end

  def xtest_tmp_file
    filename = File.dirname(__FILE__) + '/fixtures/tmp.rb'
    src = File.read(filename)
    result = build(src, filename).to_ruby(true)
    puts diff(src, result)
  end

  def xtest_this
    src = 'a+ a +a'
    pp sexp(src)
    log(src)
    #assert_equal src, build(src).to_ruby(true)
  end
end