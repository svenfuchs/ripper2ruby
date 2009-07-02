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
    
    def dynamic?
      !elements.inject(true) { |result, element| result && element.respond_to?(:value) }
    end
    
    def respond_to?(method)
      return false if method.to_sym == :value && dynamic?
      super
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