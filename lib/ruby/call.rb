require 'ruby/args'

module Ruby
  class Call < Aggregate
    child_accessor :identifier, :separator, :target, :arguments, :block

    def initialize(target, separator, identifier, arguments = nil, block = nil)
      self.target = target
      self.separator = separator
      self.identifier = identifier
      self.arguments = arguments
      self.block = block
    end

    def token
      identifier.token
    end

    def nodes
      [target, separator, identifier, arguments, block].flatten.compact
    end
  end

  class Alias < Call
    def initialize(identifier, arguments)
      self.identifier = identifier
      self.arguments = arguments
    end

    def nodes
      [identifier, arguments].flatten
    end
  end
end