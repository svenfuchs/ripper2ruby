require 'ruby/node'

module Ruby
  class Method < Node
    child_accessor :target, :separator, :identifier, :params, :body, :ldelim, :rdelim

    def initialize(target, separator, identifier, params, body, ldelim, rdelim)
      self.target = target
      self.separator = separator
      self.identifier = identifier
      self.params = params
      self.body = body
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
    
    def nodes
      [ldelim, target, separator, identifier, params, body, rdelim].compact
    end
  end
end