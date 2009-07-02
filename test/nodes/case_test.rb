require File.dirname(__FILE__) + '/../test_helper'

class CaseTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test case expression (1)' do
    src = "case a; when 1; 2 end"
    assert_build(src) do |node|
      assert_equal Ruby::Case, node.first.class
    end

  end
  
  define_method :'test case expression (2)' do
    src = "case (a) when 1; 2 end"
    assert_build(src)
  end
  
  define_method :'test case expression (3)' do
    src = "case (a;) when 1; 2 end"
    assert_build(src)
  end
  
  define_method :'test case expression (4)' do
    src = "case (a); when 1; 2 end"
    assert_build(src)
  end
  
  define_method :'test case expression (5)' do
    src = "case (a;); when 1; 2 end"
    assert_build(src)
  end
  
  define_method :'test case expression (6)' do
    src = "case (a;b); when 1; 2 end"
    assert_build(src)
  end
  
  define_method :'test when expression (1)' do
    src = "case a; when 1; 2 end"
    assert_build(src)
  end
  
  define_method :'test when expression (2)' do
    src = "case a; when 1, 2; 2 end"
    assert_build(src)
  end
  
  define_method :'test when expression (3)' do
    src = "case a; when (1; 2), (3; 4;); 2 end"
    assert_build(src)
  end
  
  define_method :'test case block, semicolon separated (4)' do
    src = "case (true); when 1; false; when 2, 3, 4; nil; else; nil; end"
    assert_build(src)
  end
  
  define_method :'test case block, newline separated' do
    src = "case true\n when 1\n false\n when 2\n nil\n else\n nil\n end"
    assert_build(src)
  end
  
  define_method :'test case block, newline separated, using then' do
    src = "case true\n when 1 then false\n when 2 then nil\n else\n nil\n end"
    assert_build(src)
  end
end