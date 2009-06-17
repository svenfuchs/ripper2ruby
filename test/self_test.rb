require File.dirname(__FILE__) + '/test_helper'

SRC = <<-src

src

class SelfTest < Test::Unit::TestCase
  include TestHelper
  
  def filenames
    Dir["#{File.dirname(__FILE__)}/../**/*.rb"].sort
  end
  
  def test_self_build
    assert_nothing_raised do
      filenames.each do |filename|
        putc '.'
        build(File.read(filename) ).to_ruby
      end
    end
  end
  
  def xtest_self
    build(SRC).to_ruby
  end
  
  def xtest_self
    src = 'return element if a'
    pp sexp(src)
    assert_equal src, build(src).to_ruby(true)
  end
end