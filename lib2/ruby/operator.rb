require 'ruby/node'

module Ruby
  class Unary < Node
    attr_accessor :operator, :operand

    def initialize(operator, operand)
      self.operator = operator
      self.operand = operand
    end
    
    def nodes
      [operator, operand]
    end
  end
  
  class Binary < Node
    attr_accessor :operator, :left, :right

    def initialize(operator, left, right)
      self.operator = operator
      self.left = left 
      self.right = right
    end
    
    def nodes
      [left, operator, right]
    end
  end
  
  class IfOp < Node
    attr_accessor :condition, :left, :right, :operators

    def initialize(condition, left, right, operators)
      self.condition = condition
      self.left = left
      self.right = right
      self.operators = operators
    end
    
    def nodes
      [[condition, left, right].zip(operators)].flatten.compact
    end
  end
end