require 'ruby/node'

module Ruby
  class Token < Node 
    attr_accessor :token, :position, :whitespace

    def initialize(token, position = nil, whitespace = nil)
      self.token = token
      self.position = position
      self.whitespace = whitespace || ''
    end
    
    def position=(position)
      @position = position.dup
    end
    
    def to_ruby(whitespace = false)
      (whitespace ? self.whitespace : '') + token.to_s
    end
      
    def to_identifier
      Identifier.new(token, position, whitespace) 
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