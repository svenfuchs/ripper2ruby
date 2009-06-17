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
