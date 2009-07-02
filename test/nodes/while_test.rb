require File.dirname(__FILE__) + '/../test_helper'

# while expression; statement; end
# begin statement end while expression
# statement while expression

class WhileTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test while block, semicolon separated' do
    src = "while true; false end"
    assert_build(src) do |node|
      assert_equal Ruby::While, node.first.class
    end
  end
  
  define_method :'test while block, semicolon separated (2)' do
    src = "while (true); false end"
    assert_build(src)
  end
  
  define_method :'test while block, semicolon separated (3)' do
    src = "while (true;true); false end"
    assert_build(src)
  end

  define_method :'test while block, newline separated' do
    src = "while true\n false end"
    assert_build(src)
  end

  define_method :'test while block, newline separated (2)' do
    src = "while (true)\n false end"
    assert_build(src)
  end
  
  define_method :'test while with do block' do
    src = "while foo do ; end"
    assert_build(src)
  end
  
  define_method :'test begin do while block, semicolon separated' do
    src = "begin; false; end while true"
    assert_build(src)
  end
  
  define_method :'test begin do while block, semicolon separated (2)' do
    src = "begin; false; end while (true)"
    assert_build(src)
  end
  
  define_method :'test begin do while block, newline separated' do
    src = "begin\n false\n end while true"
    assert_build(src)
  end
  
  define_method :'test begin do while block, newline separated (2)' do
    src = "begin\n false\n end while (true)"
    assert_build(src)
  end
  
  define_method :'test while modifier' do
    src = "foo while true"
    assert_build(src)
  end
  
  define_method :'test while modifier (2)' do
    src = "foo while (true)"
    assert_build(src)
  end
end
