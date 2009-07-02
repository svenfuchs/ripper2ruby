require File.dirname(__FILE__) + '/../test_helper'

class SeparatorsTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test separators in method definition (1)" do
    src = "def foo\n  ;bar\nend"
    assert_build(src)
  end

  define_method :"test separators in method definition (2)" do
    src = "def foo;\nend"
    assert_build(src)
  end
end

# def foo
#   ;
# end
# 
# def foo
#   bar;
# end
# 
# def foo
#   bar
#   ;
# end
# 
# def foo
#   ;bar
# end
# 
# def foo
#   ;
#   bar
# end
# 
# def foo
#   ;bar;
# end
# 
# def foo
#   ;
#   bar
#   ;
# end
# 
# def foo(a, b)
# end
# 
# foo { |a, b| }
# foo { |a, b| ; }
# foo { |a, b| bar; }
# foo { |a, b| ;bar }
# 
# foo do |a, b| 
#   ;
# end
# 
# foo do
#   bar;
# end
# 
# foo do
#   bar
#   ;
# end
# 
# foo do
#   ;bar
# end
# 
# foo do
#   ;
#   bar
# end
# 
# foo do
#   ;bar;
# end
# 
# foo do
#   ;
#   bar
#   ;
# end
# 
# begin
#   ;
# rescue
#   ;
# else
#   ;
# ensure
#   ;
# end