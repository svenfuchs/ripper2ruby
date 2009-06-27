require 'ruby/node'

module Ruby
  class Token < Node
    include Conversions::Token

    attr_accessor :token, :position, :prolog

    def initialize(token = '', position = nil, prolog = nil)
      self.token = token
      self.position = position if position
      self.prolog = prolog if prolog
    end

    def position(prolog = false)
      (self.prolog.try(:position) if prolog) || @position
    end

    def position=(position)
      @position = position.dup if position
    end

    def to_s
      token.to_s
    end

    def to_ruby(prolog = false)
      (prolog && self.prolog.try(:to_ruby, prolog) || '') + token.to_s
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
    attr_accessor :heredoc
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