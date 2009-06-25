require 'ruby/statements'

module Ruby
  class Block < Statements
    child_accessor :params
    
    def initialize(statements, params = nil, ldelim = nil, rdelim = nil)
      self.params = params
      super(statements, ldelim, rdelim)
    end
    
    def nodes
      [ldelim, params, elements, rdelim].flatten.compact
    end
  end
  
  class NamedBlock < Block
    child_accessor :identifier
    
    def initialize(identifier, statements, params = nil, ldelim = nil, rdelim = nil)
      self.identifier = identifier
      super(statements, params, ldelim, rdelim)
    end
    
    def nodes
      [identifier, super].flatten.compact
    end
  end
  
  class ChainedBlock < NamedBlock
    child_accessor :blocks

    def initialize(identifier, blocks, statements, params = nil, ldelim = nil, rdelim = nil)
      self.blocks = Array(blocks) || []
      super(identifier, statements, params, ldelim, rdelim)
    end
    
    def nodes
      [identifier, params, ldelim, elements, blocks, rdelim].flatten.compact
    end
  end
end