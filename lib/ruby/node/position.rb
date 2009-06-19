module Ruby
  class Node
    class Position
      attr_accessor :row, :col
      
      def initialize(row, col)
        @row = row
        @col = col
      end
      
      def [](ix)
        ix == 0 ? row : col
      end
    
      def <=>(other)
        row < other.row ? -1 : row > other.row ?  1 : col <=> other.col
      end
      
      def ==(other)
        to_a == other
      end
      
      def to_a
        [row, col]
      end
    end
  end
end