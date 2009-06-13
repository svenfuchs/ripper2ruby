require 'ruby/assoc'

module Ruby
  class Hash < Node
    child_accessor :assocs, :ldelim, :rdelim, :separators

    def initialize(assocs = nil, ldelim = nil, rdelim = nil, separators = nil)
      self.ldelim = ldelim
      self.rdelim = rdelim
      self.assocs = assocs || []
      self.separators = separators || []
    end
    
    def [](key)
      each { |assoc| return assoc.value if assoc.key.value == key } or nil
    end
    
    def []=(key, value)
      value = from_native(value, nil, ' ') unless value.is_a?(Node)
      if assoc = assocs.detect { |assoc| assoc.key.value == key }
        assoc.value = value
      else
        # TODO never happens, fix positions
        separators << Token.new(',')
        assocs << Assoc.new(key, value)
        self[key]
      end
    end
    
    def delete(key)
      delete_if { |assoc| assoc.key.value == key }
    end
    
    def value
      code = to_ruby(false)
      code = "{#{code}}" unless code =~ /^\s*{/
      eval(code) rescue {}
    end
    
    def nodes
      [ldelim, zip(separators), rdelim].flatten.compact
    end
    
    def method_missing(method, *args, &block)
      @assocs.respond_to?(method) ? @assocs.send(method, *args, &block) : super
    end
  end
end