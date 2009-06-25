require 'ruby/statements'

module Ruby
  class For < NamedBlock
    child_accessor :variable, :operator, :range

    def initialize(identifier, variable, operator, range, statements, ldelim = nil, rdelim = nil)
      self.variable = variable
      self.operator = operator
      self.range = range
      super(identifier, statements, nil, ldelim, rdelim)
    end
      
    def nodes
      [identifier, variable, operator, range, ldelim, elements, rdelim].flatten.compact
    end
  end
end