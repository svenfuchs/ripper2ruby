require File.dirname(__FILE__) + '/test_helper'

SRC = <<-src
class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Token
      def initialize(type = nil, value = nil, position = nil)
        @type = type == :@kw ? :"@\#{value.gsub(/\W/, '')}" : type
        # @value = value
        # @whitespace = ''
        # @comments = []
        #       
        # position[0] -= 1 if position
        # @position = position
      end
      
      # def row
      #   position[0]
      # end
      # 
      # def column
      #   position[1]
      # end
      # 
      # def whitespace?
      #   WHITESPACE.include?(type)
      # end
      # 
      # def opener?
      #   OPENERS.include?(type)
      # end
      # 
      # def comment?
      #   type == :@comment
      # end
      # 
      # def to_sexp
      #   [type, value, [row + 1, column]]
      # end
      # 
      # def to_identifier
      #   Ruby::Identifier.new(value, position, whitespace)
      # end
    end
  end
end
src

class SelfTest < Test::Unit::TestCase
  include TestHelper
  
  def filenames
    Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"]
  end
  
  define_method :"xtest can build itself" do
    filenames.each do |filename|
      puts filename
      src = File.read(filename) 
      build(src).to_ruby
    end
  end
  
  def xtest_self
    build(SRC).to_ruby
  end
  
  # @\#{value.gsub(/\W/, '')}
  def xtest_self
    src = "a = b == c ? 1 : 2"
    pp sexp(src)
    assert_equal src, build(src).to_ruby(true)
  end
end