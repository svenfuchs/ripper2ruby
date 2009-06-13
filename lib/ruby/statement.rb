require 'ruby/token'

module Ruby
  class Statement < Node
    child_accessor :statement, :rdelim

    def initialize(statement, rdelim)
      self.statement = statement
      self.rdelim = rdelim
    end
    
    def nodes
      [statement, rdelim].compact
    end
    
    def method_missing(method, *args, &block)
      statement.respond_to?(method) ? statement.send(method, *args, &block) : super
    end
  end
end