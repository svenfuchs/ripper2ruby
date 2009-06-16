require 'ruby/statements'

module Ruby
  class For < Statements
    child_accessor :variable, :operator, :range
    
    def initialize(variable, operator, range, statements, separators, ldelim = nil, rdelim = nil)
      self.variable = variable
      self.operator = operator
      self.range = range
      super(statements, separators, ldelim, rdelim)
    end
      
    def nodes
      [ldelim, variable, operator, range, contents, rdelim].flatten.compact
    end
  end
end