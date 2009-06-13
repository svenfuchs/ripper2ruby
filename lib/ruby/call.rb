require 'ruby/args'

module Ruby
  class Call < Node
    child_accessor :identifier, :separator, :target, :arguments, :block

    def initialize(target, separator, identifier, arguments = nil, block = nil)
      target = Unsupported.new(target) if target && !target.is_a?(Node)

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
end