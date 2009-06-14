require 'ruby/params'

module Ruby
  class Body < Node
    child_accessor :statements
    
    def initialize(statements)
      self.statements = statements
    end
    
    def nodes
      statements
    end
    
    def method_missing(method, *args, &block)
      statements.respond_to?(method) ? statements.send(method, *args, &block) : super
    end
  end
end