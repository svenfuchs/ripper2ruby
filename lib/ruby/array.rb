require 'ruby/node'

module Ruby
  class Array < Node
    child_accessor :elements, :separators, :ldelim, :rdelim
    
    def initialize(elements, ldelim, rdelim = nil, separators = nil)
      self.ldelim = ldelim
      self.rdelim = rdelim
      self.elements = elements || []
      self.separators = separators || []
    end
    
    def <<(element)
      elements << element
      self
    end
    
    def value
      map { |element| element.value }
    end
    
    def nodes
      [ldelim, zip(separators), rdelim].flatten.compact
    end
    
    def method_missing(method, *args, &block)
      elements.respond_to?(method) ? elements.send(method, *args, &block) : super
    end
  end
  
  class Range < Node
    child_accessor :left, :operator, :right
    
    def initialize(left, operator, right)
      self.left = left
      self.operator = operator
      self.right = right
    end
    
    def nodes
      [left, operator, right]
    end
  end
end