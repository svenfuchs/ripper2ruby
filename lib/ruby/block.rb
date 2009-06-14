require 'ruby/body'

module Ruby
  class Block < Body
    child_accessor :params, :ldelim, :rdelim
    
    def initialize(statements, rescue_block = nil, ensure_block = nil, params = nil, ldelim = nil, rdelim = nil)
      self.params = params
      self.ldelim = ldelim
      self.rdelim = rdelim
      super(statements, rescue_block, ensure_block)
    end
    
    def nodes
      [ldelim, params, super, rdelim].flatten.compact
    end
  end
  
  class NamedBlock < Block
    child_accessor :identifier
    
    def initialize(identifier, statements, ldelim = nil, rdelim = nil)
      self.identifier = identifier
      super(statements, nil, nil, nil, ldelim, rdelim)
    end
    
    def nodes
      [identifier, super].flatten.compact
    end
  end
end