require File.dirname(__FILE__) + '/../test_helper'

class NodesTest < Test::Unit::TestCase
  include TestHelper

  lines = File.read(File.dirname(__FILE__) + '/../fixtures/all.rb.src').split("\n")
  lines.each do |line|
    next if line =~ /^#/ || line.empty?
    define_method :"test: to_ruby(#{line}) compiles to the original src" do
      line.gsub!('\n', "\n")
      assert_equal line, build(line).first.to_ruby
      assert_equal line, build(line).first.src
    end
  end
end
