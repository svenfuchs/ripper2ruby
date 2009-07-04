require 'ruby/node'

module Ruby
  class Statements < DelimitedList
    include Conversions::Statements
  end
  
  class Program < Statements
    child_accessor :end_data
    attr_accessor :filename
    attr_writer :src

    def initialize(src, filename, statements = [], end_data = nil)
      self.src = src
      self.filename = filename if filename
      self.end_data = end_data if end_data
      super(statements)
    end
    
    alias :statements :elements
    
    def to_ruby(prolog = false)
      super(true)
    end
    
    def nodes
      [super, end_data].flatten.compact
    end
    
    # TODO replace this with Clip?
    def line_pos(row)
      (row > 0 ? src.split("\n")[0..(row - 1)].inject(0) { |pos, line| pos + line.length + 1 } : 0)
    end
    
    def replace_src(row, column, length, src)
      self.src[line_pos(row) + column, length] = src 
      offset_column = src.length - length
      update_positions(row, column + length, offset_column)
    end
    
    def save_src
      File.open(filename, 'w+') { |f| f.write(src) }
    end
  end
end
