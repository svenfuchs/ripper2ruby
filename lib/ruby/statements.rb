require 'ruby/node'

module Ruby
  class Statements < DelimitedList
    def statements
      elements
    end
    
    def to_block(separators = [], params = nil, ldelim = nil, rdelim = nil)
      Block.new(statements, self.separators + separators, params, ldelim, rdelim)
    end
    
    def to_named_block(identifier = nil, separators = [], params = nil, ldelim = nil, rdelim = nil)
      NamedBlock.new(identifier = nil, statements, self.separators + separators, params, ldelim, rdelim)
    end
    
    def to_chained_block(identifier = nil, blocks = nil, separators = [], params = nil, ldelim = nil, rdelim = nil)
      ldelim ||= self.ldelim
      rdelim ||= self.rdelim
      identifier ||= self.identifier if respond_to?(:identifier)
      ChainedBlock.new(identifier, blocks, statements, self.separators + separators, params, ldelim, rdelim)
    end
    
    def to_program(src, filename)
      Program.new(src, filename, elements, separators)
    end
  end
  
  class Program < Statements
    attr_accessor :src, :filename

    def initialize(src, filename, statements, separators)
      self.src = src
      self.filename = filename
      super(statements, separators)
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
