require 'ruby/identifier'

module Ruby
  class Const < Identifier
    child_accessor :namespace, :separator
    
    def src_pos(include_whitespace = false)
      namespace ? namespace.src_pos(include_whitespace) : super
    end
    
    def position
      namespace ? namespace.position : super
    end
    
    def whitespace
      namespace ? namespace.whitespace : super
    end
    
    def nodes
      [namespace, separator].compact
    end

    def to_ruby(include_whitespace = false)
      (include_whitespace ? whitespace : '') + nodes.map { |node| node.to_ruby(true) }.join.strip + token.to_s
    end
  end
  
  class Module < DelimitedNode
    child_accessor :const, :body

    def initialize(const, body, ldelim, rdelim)
      self.const = const
      self.body = body
      super(ldelim, rdelim)
    end

    def nodes
      [ldelim, const, body, rdelim].compact
    end
  end

  class Class < DelimitedNode
    child_accessor :const, :operator, :super_class, :body

    def initialize(const, operator, super_class, body, ldelim, rdelim)
      self.const = const
      self.operator = operator
      self.super_class = super_class
      self.body = body
      super(ldelim, rdelim)
    end

    def nodes
      [ldelim, const, operator, super_class, body, rdelim].compact
    end
  end
end