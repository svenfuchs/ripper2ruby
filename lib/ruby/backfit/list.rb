module Ruby
  module Backfit
    module List
      def <<(element)
        elements << element
        self
      end
    
      def pop
        [elements.pop, separators.pop]
      end
    
      def []=(ix, element)
        element = to_node(element, self[ix].position, self[ix].whitespace)
        super
      end
    end
  end
end