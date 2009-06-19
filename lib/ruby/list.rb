require 'ruby/node'
require 'ruby/backfit/list'

module Ruby
  class List < Aggregate
    include Backfit::List
    
    child_accessor :elements, :separators
    
    def initialize(elements = nil, separators = nil)
      self.elements = Array(elements)
      self.separators = Array(separators)
    end
    
    def nodes
      contents
    end
    
    def contents
      (elements + separators).flatten.compact.
      # sort { |a, b| a.row < b.row ? -1 : a.row > b.row ?  1 : a.column <=> b.column }
      sort { |a, b| a.position <=> b.position }
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
