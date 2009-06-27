require File.dirname(__FILE__) + '/../test_helper'

class StackTest < Test::Unit::TestCase
  def setup
    @builder = Ripper::RubyBuilder.new('')
  end
  
  def push(*types)
    types.each { |type| @builder.send(:push, Array(type)) }
  end
  
  def stack
    @builder.stack
  end

  # define_method "test pop: pops off elements until it finds a token with the requested type" do
  #   push(:@lbrace, :@comma, :@comma, :@rbrace)
  # 
  #   assert_equal :@rbrace, @builder.send(:pop, :@rbrace).first.type
  #   assert !@builder.stack.empty?
  #   assert @builder.send(:pop, :foo).empty?
  # 
  #   commas = @builder.send(:pop, :@comma)
  #   assert_equal 2, commas.length
  #   assert_equal :@comma, commas[0].type
  #   assert_equal :@comma, commas[1].type
  # 
  #   assert_equal :@lbrace, @builder.send(:pop, :@lbrace).first.type
  #   assert @builder.stack.empty?
  #   assert @builder.send(:pop, :foo).empty?
  # end
  # 
  # define_method "test pop: leaves the stack untouched if it does not find a token with the requested type" do
  #   push(:@lbrace, :@comma, :@comma, :@rbrace)
  # 
  #   assert @builder.send(:pop, :foo).empty?
  #   assert !@builder.stack.empty?
  #   assert !@builder.send(:pop, :@rbrace).empty?
  # end
  # 
  # define_method "test push: pushes non-opening tokens directly to the stack" do
  #   push(:@rbrace)
  #   assert_equal :@rbrace, stack.last.type
  # end
  
  # define_method "test push: opening tokens are queued and then pushed together with the next token" do
  #   push([:@sp, ' '], [:@sp, ' '], :@lbrace)
  #   assert_equal nil, stack.last
  #   assert_equal :@lbrace, stack.queue.last.type
  #   assert_equal nil,  @builder.send(:pop_context)
  #   
  #   push(:@rbrace)
  #   assert_equal :@rbrace, stack[1].type
  #   assert_equal :@lbrace, stack[0].type
  #   assert_equal '  ', stack[0].context.whitespace.token
  #   assert_equal nil,  stack.queue.last
  # end
  # 
  # define_method "test push: context can be obtained by identifiers, keywords, etc." do
  #   push([:@sp, ' '])
  #   context = @builder.send(:pop_context)
  #   assert_not_nil context.whitespace.token
  #   assert_equal ' ',  context.whitespace.token
  # end
end


