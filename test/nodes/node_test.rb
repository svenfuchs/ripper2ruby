require File.dirname(__FILE__) + '/../test_helper'

class NodeTest < Test::Unit::TestCase
  def statements(src)
    Ripper::RubyBuilder.build(src).statements
  end
  
  # def test_src_pos
  #   statements = statements("  aaaaaaa\nbbbbb\ncccc(:c)\nddd\nee\nf")
  #   assert_equal 2,  statements[0].src_pos
  #   assert_equal 10, statements[1].src_pos
  #   assert_equal 16, statements[2].src_pos
  #   assert_equal 21, statements[2].arguments.first.src_pos
  #   assert_equal 25, statements[3].src_pos
  #   assert_equal 29, statements[4].src_pos
  #   assert_equal 32, statements[5].src_pos
  # end
  
  # def test_update_position
  #   program = Ripper::RubyBuilder.build("a\nb\nc(:c); d(:d); e(:e)\nf")
  #   
  #   b = program.statements[1]
  #   c = program.statements[2]
  #   d = program.statements[3]
  #   e = program.statements[4]
  #   f = program.statements[5]
  #   
  #   assert_equal [1, 0],  b.position
  #   assert_equal [2, 0],  c.position
  #   assert_equal [2, 7],  d.position
  #   assert_equal [2, 14], e.position
  #   assert_equal [3, 0],  f.position
  # 
  #   program.send(:update_positions, 2, c.length, 3)
  #   
  #   assert_equal [1, 0],  b.position
  #   assert_equal [2, 0],  c.position
  #   assert_equal [2, 10], d.position
  #   assert_equal [2, 17], e.position
  #   assert_equal [3, 0],  f.position
  # end
  # 
  # def test_update_children_positions
  #   program = Ripper::RubyBuilder.build("a(:a); b(:b, ['b', 1], { :b => :'b' })")
  #   
  #   a = program.statements.select { |s| s.identifier.token == 'a' if s }.first
  #   b = program.statements.select { |s| s.identifier.token == 'b' if s }.first
  #   
  #   assert_equal [0, 0],  a.position
  #   assert_equal [0, 7],  b.position
  #   assert_equal [0, 9],  b.arguments[0].position
  #   assert_equal [0, 13], b.arguments[1].position
  #   assert_equal [0, 14], b.arguments[1][0].position
  #   assert_equal [0, 19], b.arguments[1][1].position
  #   assert_equal [0, 23], b.arguments[2].position
  #   assert_equal [0, 25], b.arguments[2].assocs[0].position
  #   assert_equal [0, 25], b.arguments[2].assocs[0].key.position
  #   assert_equal [0, 31], b.arguments[2].assocs[0].value.position
  #   v = b.arguments[2].assocs[0].value
  # 
  #   program.send(:update_positions, 0, a.length, 3)
  # 
  #   assert_equal [0, 0],  a.position
  #   assert_equal [0, 10], b.position
  #   assert_equal [0, 12], b.arguments[0].position
  #   assert_equal [0, 16], b.arguments[1].position
  #   assert_equal [0, 17], b.arguments[1][0].position
  #   assert_equal [0, 22], b.arguments[1][1].position
  #   assert_equal [0, 26], b.arguments[2].position
  #   assert_equal [0, 28], b.arguments[2].assocs[0].position
  #   assert_equal [0, 28], b.arguments[2].assocs[0].key.position
  #   assert_equal [0, 34], b.arguments[2].assocs[0].value.position
  # end
end