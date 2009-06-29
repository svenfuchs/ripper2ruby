module Ruby
  class Node
    module Traversal
      def select(*args)
        result = []
        result << self if matches?(args.dup) || block_given? && yield(self)
        nodes.inject(result) { |result, node| result + node.select(*args) }
      end

      def matches?(args)
        conditions = args.last.is_a?(::Hash) ? args.pop : {}
        conditions[:type] = args unless args.empty?
        conditions.inject(true) do |result, (type, value)|
          result && case type
          when :type
            has_type?(value)
          when :token
            has_token?(value)
          when :value
            has_value?(value)
          when :pos, :position
            position?(value)
          when :right_of
            right_of?(value)
          when :left_of
            left_of?(value)
          end
        end
      end

      def has_type?(type)
        case type
        when ::Array
          type.each { |type| return true if is_a?(type) }
          false
        else
          is_a?(type) # allow to pass a symbol or string, too
        end 
      end

      def has_token?(token)
        case token
        when ::Array
          token.include?(self.token)
        else
          self.token == token 
        end if respond_to?(:token)
      end

      def has_value?(value)
        case value
        when ::Array
          value.include?(self.value)
        else
          self.value == value 
        end if respond_to?(:value)
      end
      
      def position?(pos)
        position == pos
      end

      def left_of?(right)
        right.nil? || self.position < right.position
      end

      def right_of?(left)
        left.nil? || left.position < self.position
      end
    end
  end
end