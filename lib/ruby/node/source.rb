# Factor out a class that represents a file, can be saved etc and extends a 
# class that represents an array of lines which can be navigated based on
# row/column information (rather than absolute positions/length such String)
# This class could probably be reused to model the context.

module Ruby
  class Node
    module Source
      def filename
        root? ? @filename : root.filename
      end

      def src_pos(whitespace = false)
        line_pos(row) + column - (whitespace ? whitespace.length : 0)
      end

      def src(whitespace = false)
        root? ? @src : root.src[src_pos(whitespace), length(whitespace)]
      end

      def lines
        root.src.split("\n")
      end

      def line_pos(row)
        (row > 0 ? lines[0..(row - 1)].inject(0) { |pos, line| pos + line.length + 1 } : 0)
      end

      # TODO what if a node spans multiple lines (like a block, method definition, ...)?
      def line(options = {})
        highlighter = options.has_key?(:highlight) ? options[:highlight] : false
        line = lines[row].dup
        highlighter ? line_head + highlighter.highlight(to_ruby) + line_tail : line
      end

      # excerpt from source, preceding and succeeding [Ruby.context_width] lines
      def context(options = {})
        (context_head(options) + [line(options)] + context_tail(options)).join("\n")
      end

      def context_head(options = {})
        width = options.has_key?(:width) ? options[:width] : Ruby.context_width
        min = [0, row - width].max
        min < row ? lines[min..(row - 1)] : []
      end

      def context_tail(options = {})
        width = options.has_key?(:width) ? options[:width] : Ruby.context_width
        max = [row + width, lines.size].min
        max > row ? lines[(row + 1)..max] : []
      end

      # all content that precedes the node in the first line of the node in source
      def line_head
        column == 0 ? '' : line[0..[column - 1, 0].max].to_s
      end

      # all content that succeeds the node in the last line of the node in source
      def line_tail
        line[(column + length)..-1].to_s
      end
    end
  end
end