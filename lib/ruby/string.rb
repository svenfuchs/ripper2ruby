require 'ruby/node'

module Ruby
  class StringConcat < List
  end
  
  class String < DelimitedList
    def initialize(contents = nil, ldelim = nil, rdelim = nil)
      super(contents, ldelim, rdelim)
    end
    
    def value
      map { |content| content.value }.join
    end
  end
  
  class Heredoc < String
  end

  class StringContent < Token
    def value
      token
    end
  end
  
  class Regexp < String
  end
  
  class ExecutableString < String
  end
end