module Ruby
  module Backfit
    module List
      def <<(element)
        elements << element
        self
      end
    
      def pop
        [elements.pop]
      end
    
      def []=(ix, element)
        element = to_node(element, self[ix].position, self[ix].context)
        super
      end
    end
  end
end