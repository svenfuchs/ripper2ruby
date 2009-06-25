require 'ruby/list'

module Ruby
  class Array < DelimitedList
    def value
      elements.map { |element| element.value }
    end
  end
  
  class Range < Aggregate
    child_accessor :left, :operator, :right
    
    def initialize(left, operator, right)
      self.left = left
      self.operator = operator
      self.right = right
    end
    
    def value
      operator.token == '..' ? (left.value..right.value) : (left.value...right.value)
    end
    
    def nodes
      [left, operator, right]
    end
  end
end