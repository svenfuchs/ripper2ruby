require File.dirname(__FILE__) + '/test_helper'

SRC = <<-eoc
eoc

class SelfTest < Test::Unit::TestCase
  include TestHelper
  
  def filenames(root)
    Dir["#{root}/**/*.rb"].sort
  end
  
  def read_file(filename)
    src = File.read(filename)
    src = File.open(filename, 'r:iso-8859-1') { |f| f.read } unless src.valid_encoding?
    # src.encoding = 'utf-8'
    src
  end
  
  # def test_self_build
  #   assert_nothing_raised do
  #     filenames(File.dirname(__FILE__) + '/../').each do |filename|
  #       putc '.'
  #       build(File.read(filename) ).to_ruby
  #     end
  #   end
  # end
  
  def xtest_library
    lib = File.expand_path('~/Development/shared/rails/rails')
    # lib = File.expand_path('/usr/local/ruby19/lib/ruby/1.9.1')
    # lib = File.expand_path('~/Development/projects/adva_cms/adva_cms')
    filenames(lib).each do |filename|
      # next if filename < '/usr/local/ruby19/lib/ruby/1.9.1/tkextlib'
      # next if filename.index('tktable.rb')
      next if filename.index('/templates/') || filename.index('environment.rb') # for Rails, these are erb files
      puts filename
      build(read_file(filename)).to_ruby
    end
  end
  
  def xtest_srctest_tmp
    filename = File.dirname(__FILE__) + '/fixtures/tmp.rb'
    src = read_file(filename)
    build(src).to_ruby
  end
  
  def xtest_src
    build(SRC).to_ruby
  end
  
  def xtest_this
    src = '[1 [2]]'
    # pp sexp(src)
    assert_equal src, build(src).to_ruby(true)
  end
end