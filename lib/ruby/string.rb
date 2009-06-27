require 'ruby/node'

module Ruby
  class StringConcat < List
  end
  
  class String < DelimitedList
    def initialize(ldelim = nil, rdelim = nil)
      super(nil, ldelim, rdelim)
    end
    
    def value
      map { |content| content.value }.join
    end
  end
  
  class Heredoc < String
    # def parent=(parent)
    #   super
    #   owner.appendix = self if owner = find_owner(parent)
    # end
    # 
    # def find_owner(node)
    #   node.is_a?(ArgsList) ? node : node.parent ? find_owner(node.parent) : nil
    # end
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