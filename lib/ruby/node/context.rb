require 'ruby/aggregate'

module Ruby
  class Context < Aggregate
    attr_accessor :whitespace, :separator
    
    def initialize(whitespace = nil, separator = nil)
      self.whitespace = whitespace
      self.separator = separator
    end
    
    def empty?
      separator.nil? && whitespace.nil?
    end
    
    def nodes
      [separator, whitespace].compact
    end
  end
end