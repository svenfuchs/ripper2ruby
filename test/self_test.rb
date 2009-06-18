require File.dirname(__FILE__) + '/test_helper'

SRC = <<-eoc
eoc

class SelfTest < Test::Unit::TestCase
  include TestHelper
  
  def filenames(root)
    Dir["#{root}/**/*.rb"].sort
  end
  
  # def test_self_build
  #   assert_nothing_raised do
  #     filenames(File.dirname(__FILE__) + '/../').each do |filename|
  #       putc '.'
  #       build(File.read(filename) ).to_ruby
  #     end
  #   end
  # end
  
  def test_rails
    rails = File.expand_path('~/Development/shared/rails/rails/activesupport/test')
    # filenames = %w(
    # )
    # filenames.each do |filename|
    filenames(rails).each do |filename|
      puts filename
      build(File.read(filename) ).to_ruby
    end
  end
  
  def xtest_tmp
    build(File.read(File.dirname(__FILE__) + '/fixtures/tmp.rb')).to_ruby
  end
  
  def xtest_src
    build(SRC).to_ruby
  end
  
  def xtest_this
    src = 'A::B = 1'
    # pp sexp(src)
    assert_equal src, build(src).to_ruby(true)
  end
end