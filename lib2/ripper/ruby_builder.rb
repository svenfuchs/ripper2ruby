require 'ripper'
require 'ruby'
require 'ripper/ruby_builder/token'
require 'ripper/ruby_builder/stack'

Dir[File.dirname(__FILE__) + '/ruby_builder/events/*.rb'].each { |file| require file }

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class << self
      def build(src)
        new(src).parse
      end
    end

    WHITESPACE = [:@sp, :@nl, :@ignored_nl]
    OPENERS    = [:@lparen, :@lbracket, :@lbrace, :@class, :@module, :@def, :@begin,
                  :@while, :@until, :@for, :@if, :@elsif, :@else, :@unless, :@case, :@when]
    
    include Lexer, Statements, Const, Method, Call, Block, Args, Assignment, Operator,
            If, Case, For, While, Identifier, Literal, String, Symbol, Array, Hash

    attr_reader :src, :filename, :stack

    def initialize(src, filename = nil, lineno = nil)
      @src = src || filename && File.read(filename)
      @filename = filename
      @whitespace = ''
      @stack = []
      @stack = Stack.new
      super
    end

    protected

      def position
        [lineno - 1, column]
      end

      def push(sexp)
        stack.push(Token.new(*sexp))
      end

      def pop(*args)
        options = args.last.is_a?(::Hash) ? args.pop : {}
        if types = options[:ignore]
          stack_ignore(types) { stack.pop(*args << options) }
        else
          stack.pop(*args << options)
        end
      end
      
      def pop_token(*types)
        options = types.last.is_a?(::Hash) ? types.pop : {}
        options[:max] = 1
        pop_tokens(*types << options).first
      end

      def pop_tokens(*types)
        options = types.last.is_a?(::Hash) ? types.pop : {}
        types.map { |type| pop(type, options).map { |token| build_token(token) } }.flatten.compact
      end

      def pop_whitespace
        pop(*WHITESPACE).reverse.map { |token| token.value }.join
      end

      def stack_ignore(*types, &block)
        stack.ignore_types(*types, &block)
      end
      
      def build_token(token)
        Ruby::Token.new(token.value, token.position, token.whitespace) if token
      end
  end
end