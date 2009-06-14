require 'ruby/body'

module Ruby
  class Block < Body
    child_accessor :params, :ldelim, :rdelim
    
    def initialize(statements, params, ldelim = nil, rdelim = nil)
      self.params = params
      self.ldelim = ldelim
      self.rdelim = rdelim
      super(statements)
    end
    
    def nodes
      [ldelim, params, super, rdelim].flatten.compact
    end
  end
end