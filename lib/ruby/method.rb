require 'ruby/node'

module Ruby
  class Method < NamedAggregate
    child_accessor :target, :separator, :params, :block # TODO rename block to body

    def initialize(target, separator, identifier, params, block, ldelim, rdelim)
      self.target = target
      self.separator = separator
      self.params = params
      self.block = block
      super(identifier, ldelim, rdelim)
    end
    
    def nodes
      [ldelim, target, separator, identifier, params, block, rdelim].compact
    end
  end
end