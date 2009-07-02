module Ruby
  module Conversions
    class << self
      def included(target)
        target.send(:extend, ClassMethods)
      end
    end

    def to_node(node, position, prolog)
      node = self.class.from_native(node) unless node.is_a?(Node)
      node.position = position
      node.prolog = prolog
      node
    end
    
    module ClassMethods
      def from_native(object, position = nil, prolog = nil)
        from_ruby(object.inspect, position, prolog)
      end
      
      def from_ruby(src, position = nil, prolog = nil)
        Ripper::RubyBuilder.new(src).parse.statements.first.tap do |node|
          node.position = position if position
          node.prolog = prolog if prolog
        end
      end
    end
    
    module Token
      def to_identifier
        Identifier.new(token, position, prolog)
      end
      
      def to_string_content
        Ruby::StringContent.new(token, position, prolog)
      end
    end

    module List
      def to_array(ldelim, rdelim)
        Ruby::Array.new(elements, ldelim, rdelim)
      end
    end

    module Statements
      def to_block(params = nil, ldelim = nil, rdelim = nil)
        Block.new(elements, params, ldelim, rdelim)
      end

      def to_named_block(identifier = nil, params = nil, ldelim = nil, rdelim = nil)
        NamedBlock.new(identifier = nil, elements, params, ldelim, rdelim)
      end

      def to_chained_block(identifier = nil, blocks = nil, params = nil, ldelim = nil, rdelim = nil)
        ldelim ||= self.ldelim
        rdelim ||= self.rdelim
        identifier ||= self.identifier if respond_to?(:identifier)
        ChainedBlock.new(identifier, blocks, elements, params, ldelim, rdelim)
      end

      def to_program(src, filename, end_data)
        Program.new(src, filename, elements, end_data)
      end
    end
  end
end