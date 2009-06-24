module Ruby
  class Node
    module Composite
      class Array < ::Array
        include Composite

        def initialize(objects = [])
          objects.each { |object| self << object }
        end
      
        def detect
          each { |element| return element if yield(element) }
        end

        def <<(object)
          if object.respond_to?(:parent=)
            object.parent = self.parent 
          elsif object.respond_to?(:each)
            object.each { |o| o.try(:parent=, parent) }
          end
          super
        end
      
        def []=(ix, object)
          object.parent = parent
          super
        end
      
        def parent=(parent)
          each { |object| object.try(:parent=, parent) }
          @parent = parent
        end

        def +(other)
          self.dup.tap { |dup| other.each { |object| dup << object } }
        end
      end

      def self.included(target)
        target.class_eval do
          class << self
            def child_accessor(*names, &block)
              names.each do |name|
                attr_reader name
                define_method("#{name}=") do |value|
                  value = Composite::Array.new(value) if value.is_a?(::Array) 
                  value.parent = self if value
                  instance_variable_set(:"@#{name}", value)
                  yield(value) if block_given?
                end
              end
            end
          end
        end
      end

      attr_accessor :parent

      def root?
        parent.nil?
      end

      def root
        root? ? self : parent.root
      end
    end
  end
end