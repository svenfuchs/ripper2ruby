require 'ruby/node'

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
end