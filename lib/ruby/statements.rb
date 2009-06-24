require 'ruby/node'

module Ruby
  class Statements < DelimitedList
    include Conversions::Statements
    
    def statements
      elements
    end
  end
  
  class Program < Statements
    attr_accessor :src, :filename

    def initialize(src, filename, statements)
      self.src = src
      self.filename = filename
      super(statements)
    end
    
    def to_ruby(context = false)
      super(true)
    end
    
    # TODO replace this with Clip?
    def line_pos(row)
      (row > 0 ? src.split("\n")[0..(row - 1)].inject(0) { |pos, line| pos + line.length + 1 } : 0)
    end
    
    def replace_src(row, column, length, src)
      @src[line_pos(row) + column, length] = src 
      save_src if filename
      offset_column = src.length - length
      update_positions(row, column + length, offset_column)
    end
    
    def save_src
      File.open(filename, 'w+') { |f| f.write(src) }
    end
  end
end
