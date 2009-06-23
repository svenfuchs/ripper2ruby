require File.dirname(__FILE__) + '/../test_helper'

class HashTest < Test::Unit::TestCase
  include TestHelper
  
  def hash(src)
    build(src).first
  end

  define_method :'test a hash: { :foo => :bar }' do
    src = '{ :foo => :bar }'
    hash = hash(src)
    assert_equal Ruby::Hash, hash.class
    assert_equal src, hash.to_ruby
    assert_equal src, hash.src
    assert_equal({ :foo => :bar }, hash.value)
  end

  define_method :'test a nested hash: { :a => { :b => { :b => :c, }, }, } (w/ dangling commas)' do
    src = '{ :a => { :b => { :b => :c, }, }, }'
    hash = hash(src)
    assert_equal src, hash.to_ruby
    assert_equal src, hash.src
    assert_equal({ :a => { :b => { :b => :c } } }, hash.value)
  end
  
  define_method :'test a bare nested hash: t(:a => { :b => :b, :c => { :d => :d } })' do
    src = 't(:a => { :b => :b, :c => { :d => :d } })'
    hash = hash(src)
    assert_equal src, hash.to_ruby
    assert_equal src, hash.src
  end
  
  define_method :'test a hash: { :if => :delete } (symbol that is a keyword)' do
    src = "{ :if => :foo }"
    hash = hash(src)
    assert_equal Ruby::Hash, hash.class
    assert_equal src, hash.to_ruby
    assert_equal src, hash.src
  end
  
  define_method :'test a hash: { :if => :delete } (symbol that is a keyword)' do
    src = '{ :a => :a, :b => "#{b 1}" }'
    assert_equal src, hash(src).to_ruby
  end
  
  define_method :'test a hash: { foo: bar } (Ruby 1.9 labels)' do
    src = "{ foo: bar }"
    hash = hash(src)
    assert_equal Ruby::Hash, hash.class
    assert_equal src, hash.to_ruby
    assert_equal src, hash.src
  end
  
  define_method :'test a bare hash: t(:foo => :bar)' do
    src = 't(:a => :a, :b => :b)'
    hash = build(src).first.arguments.first.arg
  
    assert_equal Ruby::Hash, hash.class
    assert_equal :a, hash.elements[0].key.value
    assert_equal :a, hash.elements[0].value.value
  
    assert hash.root.is_a?(Ruby::Program)
    assert_equal hash, hash.first.parent
    assert_equal hash.first, hash.first.key.parent
    assert_equal hash.first, hash.first.value.parent
  
    assert_equal src, hash.root.src
    assert_equal src, hash.first.root.src
    assert_equal src, hash.first.key.root.src
    assert_equal src, hash.first.value.root.src
  
    assert_equal ':a => :a, :b => :b', hash.to_ruby
  
    assert_equal [0, 2], hash.position.to_a
    assert_equal 0, hash.row
    assert_equal 2, hash.column
    assert_equal 18, hash.length
  end
  
  define_method :'test hash assignment' do
    src = "foo[:bar] = :baz"
    assert_equal src, build(src).statements.first.to_ruby
  end
  
  define_method :'test hash length: with and without whitespace' do
    assert_equal 22, hash("  {:a=>:a,:b=>:b,:c=>:c}").length
    assert_equal 30, hash("  {:a => :a, :b => :b, :c => :c}").length
    assert_equal 30, hash("  { :a=>:a ,  :b=>:b  , :c=>:c }").length
    assert_equal 32, hash("  { :a => :a, :b => :b, :c => :c }").length
    assert_equal 34, hash("  { :a => :a, :b => :b, :c => :c }").length(true)
  end
  
  # define_method :'test bare hash length: with and without whitespace' do
  #   assert_equal 20, call("  t(:a=>:a,:b=>:b,:c=>:c)").arguments.first.length
  #   assert_equal 28, call("  t(:a => :a, :b => :b, :c => :c)").arguments.first.length
  #   assert_equal 26, call("  t( :a=>:a ,  :b=>:b  , :c=>:c )").arguments.first.length
  #   assert_equal 28, call("  t( :a => :a, :b => :b, :c => :c )").arguments.first.length
  #   assert_equal 29, call("  t( :a => :a, :b => :b, :c => :c )").arguments.first.length(true)
  # end
  
  define_method :'test hash assoc length: with and without whitespace' do
    hash = hash("  { :a  =>   :b  ,  :c=>:d,:e  => :f }")
  
    assert_whitespace(hash.elements[0].key, ' ', 2)
    assert_whitespace(hash.elements[0].value, '   ', 2)
    assert_whitespace(hash.elements[0].operator, '  ', 2)
  
    assert_whitespace(hash.elements[1].key, '  ', 2)
    assert_whitespace(hash.elements[1].value, '', 2)
    assert_whitespace(hash.elements[1].operator, '', 2)
  
    assert_whitespace(hash.elements[2].key, '', 2)
    assert_whitespace(hash.elements[2].value, ' ', 2)
    assert_whitespace(hash.elements[2].operator, '  ', 2)
  
    assert_equal 11, hash.elements[0].length
    assert_equal 12, hash.elements[0].length(true)
    assert_equal 6,  hash.elements[1].length
    assert_equal 8,  hash.elements[1].length(true)
    assert_equal 9,  hash.elements[2].length
    assert_equal 9,  hash.elements[2].length(true)
                     
    assert_equal 1,  hash.separators[0].length
    assert_equal 3,  hash.separators[0].length(true)
    assert_equal 1,  hash.separators[1].length
    assert_equal 1,  hash.separators[1].length(true)
  end
  
  def assert_whitespace(node, whitespace, length)
    assert_equal whitespace, node.whitespace.to_s
    assert_equal length, node.length
    assert_equal length + whitespace.to_s.length, node.length(true)
  end
end