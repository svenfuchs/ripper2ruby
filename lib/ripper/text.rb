class Ripper
  class Text
    class Clip
      attr_reader :lines, :row, :col, :length, :tail
      
      def initialize(lines, row, col, length)
        @lines = lines
        @row = row
        @col = col
        @length = length
      end
    
      def head
        @head ||= lines[@row][@col..-1]
      end
      
      def body
        @body ||= ''.tap do |body|
          row = @row + 1
          length = @length - head.length
          while length > 0 && (line = lines[row])
            if length - line.length > 0
              body << line 
            else
              @tail = lines[row][0..(length - 1)]
            end
            length -= line.length
            row += 1
          end
          body
        end
      end
      
      def tail
        @tail || body && @tail
      end
      
      def to_s
        head + body + tail
      end
    end
    
    attr_reader :str, :sep
    
    def initialize(str = '', sep = nil)
      @str = str
      @sep = sep || "\n"
    end
    
    def lines
      @lines ||= str.split(sep).map { |line| line + sep }
    end
    
    def clip(row, col, length)
      Clip.new(lines, row, col, length)
    end
  end
end