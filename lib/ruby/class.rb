require 'ruby/const'

module Ruby
  class Class < Node
    child_accessor :const, :operator, :super_class, :body, :ldelim, :rdelim

    def initialize(const, operator, super_class, body, ldelim, rdelim)
      self.const = const
      self.operator = operator
      self.super_class = super_class
      self.body = body
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
    
    def nodes
      [ldelim, const, operator, super_class, body, rdelim]
    end
  end
end