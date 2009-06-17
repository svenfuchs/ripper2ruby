# require File.dirname(__FILE__) + '/test_helper'
#
# class ContextTest < Test::Unit::TestCase
#   def build(code)
#     Ripper::RubyBuilder.build(code)
#   end
#
#   def lines(range)
#     range.to_a.map { |i| "    call_#{i}(:a)" }.join("\n")
#   end
#
#   define_method :"test context returns 5 lines" do
#     program = build(lines(1..10))
#     line = program.statements.select { |s| s.to_ruby == 'call_4(:a)' }[0]
#     assert_equal lines(2..6), line.context
#   end
#
#   define_method :"test context returns 3 lines when no preceeding lines present" do
#     program = build(lines(1..10))
#     line = program.statements.select { |s| s.to_ruby == 'call_1(:a)' }[0]
#     assert_equal lines(1..3), line.context
#   end
#
#   define_method :"test context returns 4 lines when only one preceeding line present" do
#     program = build(lines(1..10))
#     line = program.statements.select { |s| s.to_ruby == 'call_2(:a)' }[0]
#     assert_equal lines(1..4), line.context
#   end
#
#   define_method :"test context returns 4 lines when only one succeeding line present" do
#     program = build(lines(1..10))
#     line = program.statements.select { |s| s.to_ruby == 'call_9(:a)' }[0]
#     assert_equal lines(7..10), line.context
#   end
#
#   define_method :"test context returns 3 lines when no succeeding lines present" do
#     program = build(lines(1..10))
#     line = program.statements.select { |s| s.to_ruby == 'call_10(:a)' }[0]
#     assert_equal lines(8..10), line.context
#   end
#
#   define_method :"test context highlights elements" do
#     program = build(lines(1..10))
#     line = program.statements.select { |s| s.to_ruby == 'call_4(:a)' }[0]
#     assert_equal "    \e[0;31;1mcall_4(:a)\e[0m", line.context(:highlight => true, :width => 0)
#   end
#
# end