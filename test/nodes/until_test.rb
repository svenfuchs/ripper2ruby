require File.dirname(__FILE__) + '/../test_helper'

# until expression; statement; end
# begin statement end until expression
# statement until expression

class UntilTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test until block, semicolon separated' do
    src = "until true; false end"
    assert_build(src) do |node|
      assert_equal Ruby::Until, node.first.class
    end
  end

  define_method :'test until block, semicolon separated (2)' do
    src = "until (true); false end"
    assert_build(src)
  end

  define_method :'test until block, semicolon separated (3)' do
    src = "until (true;); false end"
    assert_build(src)
  end

  define_method :'test until block, newline separated' do
    src = "until true\n false end"
    assert_build(src)
  end

  define_method :'test until block, newline separated (2)' do
    src = "until (true)\n false end"
    assert_build(src)
  end

  define_method :'test until with do block' do
    src = "until foo do ; end"
    assert_build(src)
  end
  
  define_method :'test begin do until block, semicolon separated' do
    src = "begin; false; end until true"
    assert_build(src)
  end

  define_method :'test begin do until block, newline separated' do
    src = "begin\n false\n end until true"
    assert_build(src)
  end
  
  define_method :'test until modifier' do
    src = "foo until true"
    assert_build(src)
  end
  
  define_method :'test until modifier (2)' do
    src = "foo until (true)"
    assert_build(src)
  end
end
