require File.dirname(__FILE__) + '/../test_helper'

class IfTest < Test::Unit::TestCase
  include TestHelper

  define_method :'test if block, semicolon separated' do
    src = "if true; false end"
    assert_build(src)
  end
  
  define_method :'test if block, newline separated' do
    src = "if true\n false\n end"
    assert_build(src)
  end
  
  define_method :'test if block, newline separated' do
    src = "if true\n false\n end"
    assert_build(src)
  end

  define_method :'test if block w/ then, not separated' do
    src = "if true then false end"
    assert_build(src)
  end
  
  define_method :'test if block w/ else block, semicolon separated' do
    src = "if true; false; else; true end"
    assert_build(src)
  end
  
  define_method :'test if block w/ else block, newline separated' do
    src = "if true\n false\n else\n true end"
    assert_build(src)
  end
  
  define_method :'test if block w/ elsif block, semicolon separated' do
    src = "if true; false; elsif false; true end"
    assert_build(src)
  end
  
  define_method :'test if block w/ elsif block, newline separated' do
    src = "if true\n false\n elsif false\n true end"
    assert_build(src)
  end
  
  define_method :'test if block w/ then, else block and elsif block, semicolon separated' do
    src = "if true then false; elsif false then true; else nil end"
    assert_build(src)
  end
  
  define_method :'test if block w/ then, else block and elsif block, newline separated' do
    src = "if a == 1 then b\nelsif b == c then d\ne\nf\nelse e end"
    assert_build(src)
  end
  
  define_method :'test if modifier' do
    src = "foo if true"
    assert_build(src)
  end
  
  define_method :'test if modifier after a keyword statement' do
    src = "return if true"
    assert_build(src)
  end
  
  define_method :'test if modifier after an assignment to call' do
    src = 'foo.bar += bar if bar'
    assert_build(src)
  end
  
  define_method :'test if modifier after call multiassignment with a splat' do
    src = 'foo, bar = *baz if bum'
    assert_build(src)
  end
  
  define_method :'test if modifier after call with a splat argument' do
    src = 'foo *args if bar?'
    assert_build(src)
  end
  
  define_method :'test if modifier after array access' do
    src = 'pos[1] if pos'
    assert_build(src)
  end
  
  define_method :'test if modifier testing defined?' do
    src = 'a if (defined? a)'
    assert_build(src)
  end
  
  define_method :'test rescue modifier' do
    src = 'rescued rescue rescuing'
    assert_build(src)
  end
  
  define_method :'test rescue modifier after assignment' do
    src = 'rescued = assigned rescue rescueing'
    assert_build(src)
  end
end