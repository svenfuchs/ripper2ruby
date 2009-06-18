require 'ruby/identifier'

module Ruby
  class Const < Identifier
    child_accessor :namespace, :separator
    
    def src_pos(include_whitespace = false)
      @src_pos || nodes.each { |n| return n.src_pos if n } and super
    end
    
    def whitespace
      namespace ? namespace.whitespace : super
    end
    
    def position
      nodes.each { |n| return n.position.dup if n } && @position
    end
    
    def nodes
      [namespace, separator].compact
    end

    def to_ruby(include_whitespace = false)
      (include_whitespace ? whitespace : '') + Node.to_ruby(nodes, false) + super(false)
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