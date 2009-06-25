require 'ruby/assoc'
require 'ruby/backfit/hash'

module Ruby
  class Hash < DelimitedList
    include Backfit::Hash
    
    def value
      code = to_ruby(false)
      code = "{#{code}}" unless ldelim
      eval(code) rescue {}
    end
  end
end