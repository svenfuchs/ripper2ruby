require 'ruby/node'

module Ruby
  class Program < Body
    attr_accessor :src, :filename

    def initialize(src, filename, statements)
      self.src = src
      self.filename = filename
      
      # get rid of unsupported sexp nodes
      statements = Array(statements).flatten.select { |s| s.kind_of?(Ruby::Node) }
      super(statements)
    end
    
    def statement(&block) # TODO remove this
      @statements.each { |s| return s.statement if yield(s.statement) } or nil
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
