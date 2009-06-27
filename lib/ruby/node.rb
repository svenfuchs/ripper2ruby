require 'core_ext/object/meta_class'
require 'core_ext/object/try'
require 'ruby/node/composite'
require 'ruby/node/source'
require 'ruby/node/conversions'

module Ruby
  class Node
    include Comparable
    include Composite
    include Source
    include Conversions::Node
    
    def row
      position[0]
    end

    def column
      position[1]
    end

    def length(prolog = false)
      to_ruby(prolog).length
    end
    
    def nodes
      []
    end
    
    def <=>(other)
      position <=> (other.respond_to?(:position) ? other.position : other)
    end
    
    protected

      def update_positions(row, column, offset_column)
        pos = self.position
        pos[1] += offset_column if pos && self.row == row && self.column > column
        nodes.each { |c| c.send(:update_positions, row, column, offset_column) }
      end
  end
end
