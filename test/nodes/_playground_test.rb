# require File.dirname(__FILE__) + '/../test_helper'
# 
# class PlaygroundTest < Test::Unit::TestCase
#   include TestHelper
# 
#   def test_foo
#     src = "# foo\na"
#     src = <<-eoc
# 
# # 1
# # 2
# 
# # 3
# 
# a
# eoc
#     # pp sexp(src)
#     pp build(src)
#     puts build(src).to_ruby(true)
#   end
# end