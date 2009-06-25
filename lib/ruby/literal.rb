require 'ruby/token'

module Ruby
  class Nil < Token
    def value
      nil
    end
  end
  
  class True < Token
    def value
      true
    end
  end
  
  class False < Token
    def value
      false
    end
  end
  
  class Integer < Token
    def value
      token.to_i
    end
  end

  class Float < Token
    def value
      token.to_f
    end
  end

  class Char < Token
    def value
      token[1]
    end
  end
  
  class Label < Token
    def value
      token.gsub(':').to_sym
    end
  end
end