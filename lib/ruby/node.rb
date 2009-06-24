require 'core_ext/object/meta_class'
require 'ruby/node/composite'
require 'ruby/node/source'

module Ruby
  class Node
    class << self
      def from_native(object, position = nil, context = nil)
        from_ruby(object.inspect, position, context)
      end
      
      def from_ruby(src, position = nil, context = nil)
        Ripper::RubyBuilder.new(src).parse.statements.first.tap do |node|
          node.position = position if position
          node.context = context if context
        end
      end
    end
    
    include Comparable
    include Composite
    include Source

    def row
      position[0]
    end

    def column
      position[1]
    end

    def length(context = false)
      to_ruby(context).length
    end
    
    def nodes
      []
    end
    
    def <=>(other)
      other = other.position if other.respond_to?(:position)
      position <=> other
    end
    
    protected
    
      def from_ruby(*args)
        self.class.from_ruby(*args)
      end
    
      def from_native(*args)
        self.class.from_native(*args)
      end
    
      def to_node(node, position, context)
        node = from_native(node) unless node.is_a?(Node)
        node.position = position
        node.context = context
        node
      end

      def update_positions(row, column, offset_column)
        pos = self.position
        pos[1] += offset_column if pos && self.row == row && self.column > column
        nodes.each { |c| c.send(:update_positions, row, column, offset_column) }
      end
  end
end
