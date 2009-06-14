require 'ruby/node'

module Ruby
  class For < Body
    child_accessor :variable, :operator, :range, :ldelim, :rdelim
    
    def initialize(statements, variable, operator, range, ldelim = nil, rdelim = nil)
      self.variable = variable
      self.operator = operator
      self.range = range
      self.ldelim = ldelim
      self.rdelim = rdelim
      super(statements)
    end
      
    def nodes
      [ldelim, variable, operator, range, super, rdelim].flatten.compact
    end
  end
end