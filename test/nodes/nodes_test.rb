require File.dirname(__FILE__) + '/../test_helper'

class NodesTest < Test::Unit::TestCase
  include TestHelper

  lines = File.read(File.dirname(__FILE__) + '/../fixtures/all.rb.src').split("\n")
  lines.each do |line|
    next if line =~ /^#/ || line.empty?
    define_method :"test: to_ruby(#{line}) compiles to the original src" do
      line.gsub!('\n', "\n")
      assert_build(line)
    end
  end
  
  Dir["#{File.dirname(__FILE__)}/../fixtures/**/*.rb"].sort.each do |filename|
    # puts filename
    define_method :"test: #{filename} compiles to the original src" do
      next if filename.index('tmp.rb')
      src = File.read(filename)
      assert_build(src)
    end
  end
end
