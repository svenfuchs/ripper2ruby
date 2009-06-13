require 'ruby/node'

module Ruby
  class Unsupported < Node 
    attr_accessor :token

    def initialize(token, position = nil)
      self.token = token
      super(position)
    end
    
    def to_ruby(include_whitespace = false)
      '(unsupported type)'
    end
  end
end