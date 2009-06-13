require 'ruby/node'

module Ruby
  class Assoc < Node
    child_accessor :key, :value, :operator
    
    def initialize(key, value, operator)
      self.key = key
      self.value = value
      self.operator = operator
    end
    
    def nodes
      [key, operator, value]
    end
  end
end