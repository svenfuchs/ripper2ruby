# require File.dirname(__FILE__) + '/../test_helper'
#
# class IfTest < Test::Unit::TestCase
#   include TestHelper
#
#   define_method :'test if block, semicolon separated' do
#     src = "if true; false end"
#     expr = build(src).statements.first
#     assert_equal src, expr.to_ruby
#   end
#
#   define_method :'test if block, newline separated' do
#     src = "if true\n false end"
#     expr = build(src).statements.first
#     assert_equal src, expr.to_ruby
#   end
#
#   define_method :'test if block w/ then, not separated' do
#     src = "if true then false end"
#     expr = build(src).statements.first
#     assert_equal src, expr.to_ruby
#   end
#
#   define_method :'test if block w/ else block, semicolon separated' do
#     src = "if true; false; else; true end"
#     expr = build(src).statements.first
#     assert_equal src, expr.to_ruby
#   end
#
#   define_method :'test if block w/ else block, newline separated' do
#     src = "if true\n false\n else\n true end"
#     expr = build(src).statements.first
#     assert_equal src, expr.to_ruby
#   end
#
#   define_method :'test if block w/ elsif block, semicolon separated' do
#     src = "if true; false; elsif false; true end"
#     expr = build(src).statements.first
#     assert_equal src, expr.to_ruby
#   end
#
#   define_method :'test if block w/ elsif block, newline separated' do
#     src = "if true\n false\n elsif false\n true end"
#     expr = build(src).statements.first
#     assert_equal src, expr.to_ruby
#   end
#
#   define_method :'test if block w/ then, else block and elsif block, semicolon separated' do
#     src = "if true then false; elsif false then true; else nil end"
#     expr = build(src).statements.first
#     assert_equal src, expr.to_ruby
#   end
#
#   define_method :'test if block w/ then, else block and elsif block, newline separated' do
#     src = "if a == 1 then b\nelsif b == c then d\ne\nf\nelse e end"
#     expr = build(src).statements.first
#     assert_equal src, expr.to_ruby
#   end
#
#   define_method :'test if modifier' do
#     src = "foo if true"
#     expr = build(src).statements.first
#     assert_equal src, expr.to_ruby
#   end
# end