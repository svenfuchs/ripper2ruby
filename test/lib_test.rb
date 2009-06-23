require File.dirname(__FILE__) + '/test_helper'
# require File.dirname(__FILE__) + '/vendor/diff'
require 'diff/lcs'
require 'diff/lcs/hunk'
require 'erb/stripper'

SRC = <<-eoc
require 'ruby/node/source'

module Ruby
  class Node
  end
end
eoc

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
      # 'tktable.rb'     # invalid array access syntax? sexp fails on: [idx [a, b]]
      'cgi/html.rb',     # uses stacked heredocs
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

  def xtest_library_build
    lib = LIBS[:ruby]
    filenames(File.expand_path(lib[:path])).each do |filename|
      next if excluded?(lib, filename)
      
      puts filename
      src = read_file(filename)
      src = strip_erb(src) if erb?(lib, filename)
      src = src.split('__END__').first
      
      result = build(src).to_ruby
      unless src == result
        puts diff(src, result)
        break
      end
      assert_equal src, result
    end
  end

  def test_tmp_file
    src = File.read(File.dirname(__FILE__) + '/fixtures/tmp.rb')
    # log(src)
    result = build(src).to_ruby(true)
    puts diff(src, result)
  end

  def xtest_src
    assert_equal SRC, build(SRC).to_ruby(true)
  end

  def xtest_this
    src = 'foo *args if bar?'
    assert_equal src, build(src).to_ruby(true)
  end
end