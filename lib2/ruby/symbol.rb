require 'ruby/string'

module Ruby
  class Symbol < Node
    child_accessor :identifier, :ldelim
    
    def initialize(identifier, ldelim)
      self.identifier = identifier
      self.ldelim = ldelim
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