require File.dirname(__FILE__) + '/../test_helper'

# while expression; statement; end
# begin statement end while expression
# statement while expression

class WhileTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test while block, semicolon separated' do
    assert_compiles_to_original "while true; false end"
    assert_compiles_to_original "while (true); false end"
    assert_compiles_to_original "while (true;true); false end"
  end

  define_method :'test while block, newline separated' do
    assert_compiles_to_original "while true\n false end"
    assert_compiles_to_original "while (true)\n false end"
  end
  
  define_method :'test while with do block' do
    assert_compiles_to_original "while foo do ; end"
  end
  
  define_method :'test begin do while block, semicolon separated' do
    assert_compiles_to_original "begin; false; end while true"
    assert_compiles_to_original "begin; false; end while (true)"
  end
  
  define_method :'test begin do while block, newline separated' do
    assert_compiles_to_original "begin\n false\n end while true"
    assert_compiles_to_original "begin\n false\n end while (true)"
  end
  
  define_method :'test while modifier' do
    assert_compiles_to_original "foo while true"
    assert_compiles_to_original "foo while (true)"
  end
end
