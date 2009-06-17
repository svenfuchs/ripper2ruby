require 'ruby/statements'

module Ruby
  class Block < Statements
    child_accessor :params
    
    def initialize(statements, separators = nil, params = nil, ldelim = nil, rdelim = nil)
      self.params = params
      super(statements, separators, ldelim, rdelim)
    end
    
    def nodes
      [ldelim, params, contents, rdelim].flatten.compact
    end
  end
  
  class NamedBlock < Block
    child_accessor :identifier, :child_blocks
    
    def initialize(identifier, statements, separators = nil, params = nil, ldelim = nil, rdelim = nil)
      self.identifier = identifier
      self.child_blocks = []
      super(statements, separators, params, ldelim, rdelim)
    end
    
    def nodes
      [identifier, super].flatten.compact
    end
  end
  
  class ChainedBlock < NamedBlock
    child_accessor :blocks

    def initialize(identifier, blocks, statements, separators = nil, params = nil, ldelim = nil, rdelim = nil)
      self.blocks = Array(blocks) || []
      super(identifier, statements, separators, params, ldelim, rdelim)
    end
    
    def nodes
      [identifier, params, ldelim, contents, blocks, rdelim].flatten.compact
    end
  end
end