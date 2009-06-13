require 'ruby/const'

module Ruby
  class Module < Node
    child_accessor :const, :body, :ldelim, :rdelim

    def initialize(const, body, ldelim, rdelim)
      self.const = const
      self.body = body
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
    
    def nodes
      [ldelim, const, body, rdelim].compact
    end
  end
end