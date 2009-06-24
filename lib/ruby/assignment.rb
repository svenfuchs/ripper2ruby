require 'ruby/node'

module Ruby
  class Assignment < Aggregate # TODO DelimitedList
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

    def initialize(kind, elements = [], ldelim = nil, rdelim = nil, star = nil)
      self.kind = kind
      self.star = star
      super(elements, ldelim, rdelim)
    end
    
    def nodes
      [ldelim, star, elements, rdelim].flatten.compact
    end
  end
end