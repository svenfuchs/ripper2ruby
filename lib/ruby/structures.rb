require 'ruby/node'

module Ruby
  class If < Node 
    child_accessor :expression, :if_block, :else_block, :ldelim, :rdelim
    
    def initialize(expression, if_block, else_block, ldelim, rdelim)
      self.expression = expression
      self.if_block = if_block
      self.else_block = else_block
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
      
    def nodes
      [ldelim, expression, if_block, else_block, rdelim].flatten.compact
    end
  end
end