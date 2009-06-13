require File.dirname(__FILE__) + '/../test_helper'

class RipperToRubyNodesTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  lines = File.read(File.dirname(__FILE__) + '/../../fixtures/all.rb').split("\n")
  lines.each do |line|
    next if line =~ /^#/ || line.empty?
    define_method :"test: to_ruby(#{line}) compiles to the original src" do
      line.gsub!('\n', "\n")
      statement = build(line).statements.first
      assert_equal line, statement.to_ruby
    end
  end
end
