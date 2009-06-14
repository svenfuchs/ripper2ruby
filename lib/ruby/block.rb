require 'ruby/body'

module Ruby
  class Block < Body
    child_accessor :params, :ldelim, :rdelim
    
    def initialize(statements, rescue_block = nil, ensure_block = nil, params = nil, ldelim = nil, rdelim = nil)
      self.params = params
      self.ldelim = ldelim
      self.rdelim = rdelim
      super(statements, rescue_block, ensure_block)
    end
    
    def nodes
      [ldelim, params, super, rdelim].flatten.compact
    end
  end
  
  # class Rescue < Block
  #   child_accessor :error_types, :error_var
  #   
  #   def initialize(error_types, error_var, statements, ldelim)
  #     super(statements, nil, ldelim)
  #   end
  # end
end