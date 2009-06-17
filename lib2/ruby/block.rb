require 'ruby/list'

module Ruby
  class Block < DelimitedList
    child_accessor :params
    
    # rescue_block = nil, ensure_block = nil, 
    def initialize(statements, separators = nil, params = nil, ldelim = nil, rdelim = nil)
      self.params = params
      super(statements, separators, ldelim, rdelim) # , rescue_block, ensure_block
    end
    
    def nodes
      [ldelim, params, contents, rdelim].flatten.compact
    end
  end
  
  class NamedBlock < DelimitedList
    child_accessor :identifier
    
    def initialize(identifier, statements, separators = nil, ldelim = nil, rdelim = nil)
      self.identifier = identifier
      super(statements, separators, ldelim, rdelim)
    end
    
    def nodes
      [identifier, super].flatten.compact
    end
  end
end