require File.dirname(__FILE__) + '/test_helper'

require 'erb/stripper'

class ErbStripperTest < Test::Unit::TestCase
  def test_sexp_filename
    erb = File.read("#{File.dirname(__FILE__)}/fixtures/template.html.erb")
    ruby = Erb::Stripper.new.to_ruby(erb)
    expected = <<-src
   f.field_set do
	    column do 
		   [:foo].each do |foo|
				          t(:erb_1)
		   end
		    t(:erb_2)
		   t(:'foo.erb_3')
	   end
   end
    src
    assert_equal erb.length, ruby.length
    %w([:foo] erb_1 erb_2 foo.erb_3).each do |token|
      assert_not_nil ruby.index(token)
      assert_equal erb.index(token), ruby.index(token)
    end
    expected.split("\n").each do |token|
      assert_not_nil ruby.index(token)
    end
  end
end
