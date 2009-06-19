require 'ruby/aggregate'
require 'ruby/string'

module Ruby
  class Symbol < DelimitedAggregate
    child_accessor :identifier
    
    def initialize(identifier, ldelim)
      self.identifier = identifier
      super(ldelim)
    end
    
    def value
      identifier.token.to_sym
    end
    
    def nodes
      [ldelim, identifier].compact
    end
  end
  
  class DynaSymbol < String
    def value
      super.to_sym
    end
  end
end