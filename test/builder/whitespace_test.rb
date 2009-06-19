require File.dirname(__FILE__) + '/../test_helper'

class WhitespaceTest < Test::Unit::TestCase
  def setup
  end

  def whitespace(type, token, position)
    Ripper::RubyBuilder::Token.new(type, token, position)
  end

  define_method :"test pushing whitespace to the stack joins to existing whitespace" do
    stack = Ripper::RubyBuilder::Stack.new
    stack.push(whitespace(:@sp, ' ', [0, 0]))
    stack.push(whitespace(:@nl, "\n", [0, 1]))
    stack.push(whitespace(:@sp, "\t", [1, 0]))
    
    assert_equal " \n\t", stack.last.value
  end
  
  define_method :"test pop_whitespace pops off the topmost whitespace token" do
    builder = Ripper::RubyBuilder.new('')
    stack = builder.stack
    stack.push(whitespace(:@sp, ' ', [0, 0]))
    stack.push(whitespace(:@nl, "\n", [0, 1]))
    stack.push(whitespace(:@sp, "\t", [1, 0]))
    
    assert_equal " \n\t", builder.send(:pop_whitespace).token
  end
end