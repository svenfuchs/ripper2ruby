require 'ruby/node'

module Ruby
  class Method < Aggregate
    child_accessor :target, :separator, :identifier, :params, :block, :ldelim, :rdelim

    def initialize(target, separator, identifier, params, block, ldelim, rdelim)
      self.target = target
      self.separator = separator
      self.identifier = identifier
      self.params = params
      self.block = block
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
    
    def nodes
      [ldelim, target, separator, identifier, params, block, rdelim].compact
    end
  end
end