require 'ruby/node'

module Ruby
  class Token < Node 
    attr_accessor :token, :position, :whitespace

    def initialize(token = '', position = nil, whitespace = nil)
      self.token = token
      self.position = position
      self.whitespace = whitespace
    end
    
    def position(whitespace = false)
      if whitespace
        self.whitespace.position rescue @position
      else
        @position
      end
    end
    
    def position=(position)
      @position = position.dup if position
    end
    
    def to_s
      token.to_s
    end
    
    def to_ruby(whitespace = false)
      (whitespace ? self.whitespace.to_s : '') + token.to_s
    end
      
    def to_identifier
      Identifier.new(token, position, whitespace) 
    end
  end
  
  class Whitespace < Token
    def inspect
      token.inspect
    end
  end
  
  class Keyword < Token
  end

  class Variable < Token
  end
  
  class Identifier < Token
    def to_variable
      Variable.new(token, position, whitespace) 
    end
  end
end