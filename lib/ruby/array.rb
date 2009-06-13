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
end