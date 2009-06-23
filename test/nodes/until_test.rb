require File.dirname(__FILE__) + '/../test_helper'

# until expression; statement; end
# begin statement end until expression
# statement until expression

class UntilTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test until block, semicolon separated' do
    assert_compiles_to_original "until true; false end"
    assert_compiles_to_original "until (true); false end"
    assert_compiles_to_original "until (true;); false end"
  end

  define_method :'test until block, newline separated' do
    assert_compiles_to_original "until true\n false end"
    assert_compiles_to_original "until (true)\n false end"
  end

  define_method :'test until with do block' do
    assert_compiles_to_original "until foo do ; end"
  end
  
  define_method :'test begin do until block, semicolon separated' do
    assert_compiles_to_original "begin; false; end until true"
  end

  define_method :'test begin do until block, newline separated' do
    assert_compiles_to_original "begin\n false\n end until true"
  end
  
  define_method :'test until modifier' do
    assert_compiles_to_original "foo until true"
    assert_compiles_to_original "foo until (true)"
  end
end
