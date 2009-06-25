require 'ruby/aggregate'

module Ruby
  class Context < Aggregate
    attr_accessor :whitespace, :separator
    
    def initialize(whitespace = nil, separator = nil)
      self.whitespace = whitespace if whitespace
      self.separator = separator if separator
    end
    
    def empty?
      separator.nil? && whitespace.nil?
    end
    
    def nodes
      [separator, whitespace].compact
    end
  end
end