require 'ruby/params'

module Ruby
  class Body < Node
    child_accessor :statements, :rescue_block, :ensure_block
    
    def initialize(statements, rescue_block = nil, ensure_block = nil)
      self.statements = statements
      self.rescue_block = rescue_block
      self.ensure_block = ensure_block
    end
    
    def nodes
      [statements, rescue_block, ensure_block].flatten.compact
    end
    
    def method_missing(method, *args, &block)
      statements.respond_to?(method) ? statements.send(method, *args, &block) : super
    end
  end
end