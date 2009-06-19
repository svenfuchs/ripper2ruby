require 'core_ext/object/meta_class'
require 'ruby/node/composite'
require 'ruby/node/source'

module Ruby
  class Node
    class << self
      def from_native(object, position = nil, whitespace = nil)
        from_ruby(object.inspect, position, whitespace)
      end
      
      def from_ruby(src, position = nil, whitespace = nil)
        Ripper::RubyBuilder.new(src).parse.statements.first.tap do |node|
          node.position = position if position
          node.whitespace = whitespace if whitespace
        end
      end
    end
    
    include Composite
    include Source

    def row
      position[0]
    end

    def column
      position[1]
    end

    def length(whitespace = false)
      to_ruby(whitespace).length
    end

    def to_ruby(whitespace = false)
      nodes = self.nodes.compact
      first = nodes.shift
      (first ? first.to_ruby(whitespace) : '') + nodes.map { |node| node.to_ruby(true) }.join
    end
    
    def nodes
      []
    end
    
    protected
    
      def from_ruby(*args)
        self.class.from_ruby(*args)
      end
    
      def from_native(*args)
        self.class.from_native(*args)
      end
    
      def to_node(node, position, whitespace)
        node = from_native(node) unless node.is_a?(Node)
        node.position = position
        node.whitespace = whitespace
        node
      end

      def update_positions(row, column, offset_column)
        pos = self.position
        pos[1] += offset_column if pos && self.row == row && self.column > column
        nodes.each { |c| c.send(:update_positions, row, column, offset_column) }
      end
  end
end
