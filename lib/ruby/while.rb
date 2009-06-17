require 'ruby/node'

module Ruby
  class While < NamedBlock
    child_accessor :expression
    
    def initialize(identifier, expression, statements, separators, rdelim = nil)
      self.expression = expression
      super(identifier, statements, separators, nil, nil, rdelim)
    end
      
    def nodes
      [identifier, expression, contents, rdelim].flatten.compact
    end
  end
  
  class WhileMod < NamedBlock
    child_accessor :expression
    
    def initialize(identifier, expression, statements)
      self.expression = expression
      super(identifier, statements)
    end
      
    def nodes
      [contents, identifier, expression].flatten.compact
    end
  end
  
  class Until < While; end
  class UntilMod < WhileMod; end
end