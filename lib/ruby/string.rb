require 'ruby/node'

module Ruby
  class String < Node
    child_accessor :contents, :ldelim, :rdelim
    
    def initialize(ldelim, rdelim = nil)
      self.ldelim = ldelim
      self.rdelim = rdelim
      self.contents = []
    end
    
    def value
      map { |content| content.value }.join
    end
    
    def src_pos(include_whitespace = false)
      ldelim.src_pos(include_whitespace)
    end
    
    def nodes
      [ldelim, contents, rdelim].flatten.compact
    end
    
    def method_missing(method, *args, &block)
      contents.respond_to?(method) ? contents.send(method, *args, &block) : super
    end
  end

  class StringContent < Token
    def value
      token
    end
  end
end