require File.dirname(__FILE__) + '/../test_helper'

class UnlessTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test unless block, semicolon separated' do
    src = "unless true; false end"
    assert_build(src) do |node|
      assert_equal Ruby::Unless, node.first.class
    end
  end

  define_method :'test unless block, newline separated' do
    src = "unless true\n false end"
    assert_build(src)
  end

  define_method :'test unless block w/ then, not separated' do
    src = "unless true then false end"
    assert_build(src)
  end

  define_method :'test unless block w/ else block, semicolon separated' do
    src = "unless true; false; else; true end"
    assert_build(src)
  end

  define_method :'test unless block w/ else block, newline separated' do
    src = "unless true\n false\n else\n true end"
    assert_build(src)
  end

  define_method :'test unless modifier' do
    src = "foo unless true"
    assert_build(src)
  end

  define_method :'test chained unless and if modifiers' do
    src = "1 unless false if true"
    assert_build(src)
  end
end