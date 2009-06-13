require 'ruby/node'

module Ruby
  class Method < Node
    child_accessor :identifier, :params, :body, :ldelim, :rdelim

    def initialize(identifier, params, body, ldelim, rdelim)
      self.identifier = identifier
      self.params = params
      self.body = body
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
    
    def nodes
      [ldelim, identifier, params, body, rdelim]
    end
  end
end