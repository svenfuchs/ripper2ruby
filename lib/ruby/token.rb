require 'ruby/node'

module Ruby
  class Token < Node 
    attr_accessor :token, :position, :context

    def initialize(token = '', position = nil, context = nil)
      self.token = token
      self.position = position if position
      self.context = context if context
    end
    
    def position(context = false)
      if context
        self.context.position rescue @position
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
    
    def to_ruby(context = false)
      ruby = ''
      ruby += self.context.to_ruby(context) if context && self.context
      ruby + token.to_s
    end
      
    def to_identifier
      Identifier.new(token, position, context) 
    end
  end
  
  class Whitespace < Token
    def inspect
      token.inspect
    end
    
    def +(other)
      token.to_s + other.token.to_s
    end
    
    def empty?
      token.empty?
    end
  end
  
  class Keyword < Token
  end
  
  class HeredocBegin < Token
  end

  class Variable < Token
  end
  
  class Identifier < Token
    def to_variable
      Variable.new(token, position, context) 
    end
  end
end