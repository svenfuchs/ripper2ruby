require File.dirname(__FILE__) + '/../test_helper'

class HashTest < Test::Unit::TestCase
  include TestHelper
  
  def hash(src)
    build(src).first
  end

  define_method :'test a hash: { :foo => :bar }' do
    src = '{ :foo => :bar }'
    assert_build(src) do |node|
      assert_equal Ruby::Hash, node.first.class
      assert_equal({ :foo => :bar }, node.first.value)
    end
  end

  define_method :'test a nested hash: { :a => { :b => { :b => :c, }, }, } (w/ dangling commas)' do
    src = '{ :a => { :b => { :b => :c, }, }, }'
    assert_build(src) do |node|
      assert_equal Ruby::Hash, node.first.class
      assert_equal({ :a => { :b => { :b => :c } } }, node.first.value)
    end
  end
  
  define_method :'test a bare nested hash: t(:a => { :b => :b, :c => { :d => :d } })' do
    src = 't(:a => { :b => :b, :c => { :d => :d } })'
    assert_build(src)
  end
  
  define_method :'test a hash: { :if => :delete } (symbol that is a keyword)' do
    src = "{ :if => :foo }"
    assert_build(src)
  end
  
  define_method :'test a hash: { :if => :delete } (symbol that is a keyword)' do
    src = '{ :a => :a, :b => "#{b 1}" }'
    assert_build(src)
  end
  
  define_method :'test a hash: { foo: bar } (Ruby 1.9 labels)' do
    src = "{ foo: bar }"
    assert_build(src)
  end
  
  define_method :'test a bare hash: t(:foo => :bar)' do
    src = 't(:a => :a, :b => :b)'
    assert_build(src)
  end
  
  define_method :'test hash assignment' do
    src = "foo[:bar] = :baz"
    assert_build(src)
  end
  
  define_method :'test hash length: with and without whitespace' do
    assert_equal 22, build("  {:a=>:a,:b=>:b,:c=>:c}").first.length
    assert_equal 30, build("  {:a => :a, :b => :b, :c => :c}").first.length
    assert_equal 30, build("  { :a=>:a ,  :b=>:b  , :c=>:c }").first.length
    assert_equal 32, build("  { :a => :a, :b => :b, :c => :c }").first.length
    assert_equal 34, build("  { :a => :a, :b => :b, :c => :c }").first.length(true)
  end
  
  define_method :'test bare hash length: with and without whitespace' do
    assert_equal 20, build("  t(:a=>:a,:b=>:b,:c=>:c)").first.arguments.first.length
    assert_equal 28, build("  t(:a => :a, :b => :b, :c => :c)").first.arguments.first.length
    assert_equal 26, build("  t( :a=>:a ,  :b=>:b  , :c=>:c )").first.arguments.first.length
    assert_equal 28, build("  t( :a => :a, :b => :b, :c => :c )").first.arguments.first.length
    assert_equal 29, build("  t( :a => :a, :b => :b, :c => :c )").first.arguments.first.length(true)
  end
end