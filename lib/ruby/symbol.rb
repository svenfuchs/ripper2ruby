require 'ruby/identifier'

module Ruby
  class Symbol < Identifier
    child_accessor :ldelim
    
    def initialize(token, ldelim)
      self.ldelim = ldelim
      super(token)
    end
    
    def value
      token.to_sym
    end
    
    def whitespace # FIXME remove these ...
      ldelim.whitespace
    end
    
    def whitespace=(whitespace) # FIXME remove these ...
      ldelim.whitespace = whitespace
    end
    
    def to_ruby(include_whitespace = false)
      ldelim.to_ruby(include_whitespace) + token
    end
    
    def nodes
      [ldelim]
    end
  end
  
  class DynaSymbol < String
    def value
      super.to_sym
    end
  end
end