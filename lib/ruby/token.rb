require 'ruby/node'

module Ruby
  class Token < Node
    include Conversions::Token

    attr_accessor :token, :position, :context

    def initialize(token = '', position = nil, context = nil)
      self.token = token
      self.position = position if position
      self.context = context if context
    end

    def position(context = false)
      (self.context.try(:position) if context) || @position
    end

    def position=(position)
      @position = position.dup if position
    end

    def to_s
      token.to_s
    end

    def to_ruby(context = false)
      (context && self.context.try(:to_ruby, context) || '') + token.to_s
    end
  end

  class Whitespace < Token
    def empty?
      token.empty?
    end

    def inspect
      token.inspect
    end
  end

  class Keyword < Token
  end

  class HeredocBegin < Token
  end

  class Identifier < Token
  end

  class Variable < Token
  end
  
  class DelimitedVariable < DelimitedAggregate
    child_accessor :identifier
    
    def initialize(identifier, ldelim = nil)
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
end