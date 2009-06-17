require 'ruby/node'

module Ruby
  class String < DelimitedList
    def initialize(ldelim = nil, rdelim = nil)
      super(nil, nil, ldelim, rdelim)
    end
    
    def value
      map { |content| content.value }.join
    end
    
    def src_pos(include_whitespace = false)
      ldelim.src_pos(include_whitespace)
    end
  end

  class StringContent < Token
    def value
      token
    end
  end
  
  class ExecutableString < String
  end
end