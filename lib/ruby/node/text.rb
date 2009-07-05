require 'ruby/node/position'

module Ruby
  class Node
    class Text
      class << self
        def split(str)
          str.gsub(/\n/, "\n\000").split(/\000/)
        end
      end

      class Context
        @@width = 2
  
        class << self
          def width
            @@width
          end
  
          def width=(width)
            @@width = width
          end
        end
        
        attr_reader :lines, :line, :row, :width

        def initialize(lines, row, width = nil, line = nil)
          @lines = lines
          @line = line || lines[row]
          @row = row
          @width = width || Context.width
        end

        def to_s(options = {})
          (head + [line] + tail).join("\n")
        end

        protected

          def head
            min = [0, row - width].max
            min < row ? lines[min..(row - 1)] : []
          end

          def tail
            max = [row + width, lines.size].min
            max > row ? lines[(row + 1)..max] : []
          end
      end

      class Clip
        attr_reader :lines, :row, :col, :length, :end
      
        def initialize(lines, pos, length = nil)
          @lines = lines.is_a?(::String) ? Text.split(lines) : lines
          @row, @col = *pos
          @length = length.nil? ? self.lines.join.length : length
          init
        end
        
        def end
          @end ||= Position.new(row, col + self.length)
        end
      
        def end=(position)
          @end = Position.new(*position)
        end
      
        def head
          lines[0, row].join + lines[row][0, col]
        end
      
        def tail
          lines[self.end.row][self.end.col..-1].to_s + lines[(self.end.row + 1)..-1].join
        end
      
        def src
          lines.join
        end
      
        def to_s
          @string
        end
      
        protected
      
          def init # TODO how to simplify this?
            @string = lines[row][col, self.length]
            col = self.length - @string.length
            row = self.row + 1
            while (line = lines[row]) && col > 0
              @string << line[0..(col - 1)]
              if col - line.length >= 0
                col -= line.length
                row += 1
                self.end = [row, col]
              else
                self.end = [row, col]
                break
              end
            end
          end
      end
    
      attr_reader :str, :sep
    
      def initialize(str = '', sep = nil)
        @str = str
        @sep = sep || "\n"
      end
    
      def lines
        @lines ||= Text.split(str)
      end
    
      def clip(pos, length)
        Clip.new(lines, pos, length)
      end
    end
  end
end