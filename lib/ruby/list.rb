require 'ruby/node'

module Ruby
  class List < Node
    child_accessor :elements, :separators
    
    def initialize(elements = nil, separators = nil)
      self.elements = Array(elements)
      self.separators = Array(separators)
    end
    
    def <<(element)
      elements << element
      self
    end
    
    def pop
      [elements.pop, separators.pop]
    end
    
    def []=(ix, element)
      element = to_node(element, self[ix].position, self[ix].whitespace)
      super
    end
    
    def nodes
      contents
    end
    
    def contents
      (elements + separators).flatten.compact.
      sort { |a, b| a.src_pos <=> b.src_pos }
    end
    
    def to_array(ldelim, rdelim)
      Ruby::Array.new(elements, separators, ldelim, rdelim)
    end
    
    def method_missing(method, *args, &block)
      elements.respond_to?(method) ? elements.send(method, *args, &block) : super
    end
  end
  
  class DelimitedList < List
    child_accessor :ldelim, :rdelim
    
    def initialize(elements = nil, separators = nil, ldelim = nil, rdelim = nil)
      self.ldelim = ldelim
      self.rdelim = rdelim
      super(elements, separators)
    end
    
    def nodes
      ([ldelim] + super + [rdelim]).flatten.compact
    end
  end
end
