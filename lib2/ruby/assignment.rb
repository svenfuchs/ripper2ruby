require 'ruby/node'

module Ruby
  class Assignment < Node
    child_accessor :left, :right, :operator

    def initialize(left, right, operator)
      self.left = left
      self.right = right
      self.operator = operator
    end
    
    def nodes
      [left, operator, right].compact
    end
  end

  class MultiAssignment < DelimitedList
    attr_accessor :kind
    child_accessor :star

    def initialize(kind, elements = [], separators = [], ldelim = nil, rdelim = nil, star = nil)
      self.kind = kind
      self.star = star
      super(elements, separators, ldelim, rdelim)
    end
    
    def nodes
      [ldelim, star, contents, rdelim].flatten.compact
    end
  end
end