module Ruby
  class Node
    module Traversal
      def select(*args, &block)
        result = []
        result << self if matches?(args.dup, &block)

        children = (prolog.try(:elements).to_a || []) + nodes
        children.flatten.compact.inject(result) do |result, node|
          result + node.select(*args, &block)
        end
      end

      def matches?(args, &block)
        conditions = args.last.is_a?(::Hash) ? args.pop : {}
        conditions[:is_a] = args unless args.empty?

        conditions.inject(!conditions.empty?) do |result, (type, value)|
          result && case type
          when :is_a
            has_type?(value)
          when :class
            is_instance_of?(value)
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
        end && (!block_given? || block.call(self))
      end

      def has_type?(klass)
        case klass
        when ::Array
          klass.each { |klass| return true if has_type?(klass) } and false
        else
          is_a?(klass) # allow to pass a symbol or string, too
        end
      end

      def is_instance_of?(klass)
        case klass
        when ::Array
          klass.each { |klass| return true if has_type?(klass) } and false
        else
          instance_of?(klass) # allow to pass a symbol or string, too
        end
      end

      def has_token?(token)
        case token
        when ::Array
          type.each { |type| return true if has_token?(token) } and false
        else
          self.token == token
        end if respond_to?(:token)
      end

      def has_value?(value)
        self.value == value if respond_to?(:value)
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