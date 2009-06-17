require 'ruby/string'

module Ruby
  class Symbol < DelimitedNode
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
    
    def method_missing(method, *args, &block)
      identifier.respond_to?(method) ? identifier.send(method, *args, &block) : super
    end
  end
  
  class DynaSymbol < String
    def value
      super.to_sym
    end
  end
end