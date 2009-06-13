require File.dirname(__FILE__) + '/test_helper'

class RipperToRubyBuilderTest < Test::Unit::TestCase
  def setup
    @builder = Ripper::RubyBuilder.new('')
    @builder.push([:@lbrace])
    @builder.push([:@comma])
    @builder.push([:@comma])
    @builder.push([:@rbrace])
  end

  define_method "test pop: pops off elements until it finds a token with the requested type" do
    assert_equal :@rbrace, @builder.send(:pop, :@rbrace).first.type 
    assert !@builder.stack.empty?
    assert @builder.send(:pop, :foo).empty?

    commas = @builder.send(:pop, :@comma)
    assert_equal 2, commas.length
    assert_equal :@comma, commas[0].type 
    assert_equal :@comma, commas[1].type 

    assert_equal :@lbrace, @builder.send(:pop, :@lbrace).first.type 
    assert @builder.stack.empty?
    assert @builder.send(:pop, :foo).empty?
  end
  
  define_method "test pop: leaves the stack untouched if it does not find a token with the requested type" do
    assert @builder.send(:pop, :foo).empty? 
    assert !@builder.stack.empty?
    assert !@builder.send(:pop, :@rbrace).empty?
  end
  
  define_method "test pop: ignoring types" do
    @builder.send(:stack_ignore, :@rbrace) do
      commas = @builder.send(:pop, :@comma)
      assert_equal 2, commas.length
      assert_equal :@comma, commas[0].type
      assert_equal :@comma, commas[1].type
    end
  end
  
  define_method "test pop: ignoring types nested" do
    @builder.send(:stack_ignore, :@rbrace) do
      @builder.send(:stack_ignore, :@comma) do
        assert_equal :@lbrace, @builder.send(:pop, :@lbrace).first.type
      end
    end
  end
end