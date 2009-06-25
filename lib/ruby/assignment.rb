require 'ruby/node'

module Ruby
  class Assignment < Aggregate
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
    child_accessor :splat

    def initialize(kind, elements = [], ldelim = nil, rdelim = nil, splat = nil)
      self.kind = kind
      self.splat = splat
      super(elements, ldelim, rdelim)
    end
    
    def nodes
      [ldelim, splat, elements, rdelim].flatten.compact
    end
  end
end
