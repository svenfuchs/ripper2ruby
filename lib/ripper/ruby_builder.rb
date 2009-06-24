require 'ripper'
require 'ruby'
require 'ruby/node/context'
require 'ripper/ruby_builder/token'
require 'ripper/ruby_builder/stack'

Dir[File.dirname(__FILE__) + '/ruby_builder/events/*.rb'].each { |file| require file }

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class ParseError < RuntimeError
    end

    class << self
      def build(src, filename = nil)
        new(src, filename).parse
      end
    end

    NEWLINE           = [:@nl, :@ignored_nl]
    WHITESPACE        = [:@sp, :@comment] + NEWLINE
    OPENERS           = [:@lparen, :@lbracket, :@lbrace, :@class, :@module, :@def, :@begin, :@while, :@until, 
                         :@for, :@if, :@elsif, :@else, :@unless, :@case, :@when, :@embexpr_beg, :@do, :@rescue,
                         :'@='] # , :'@|'
    KEYWORDS          = [:@alias, :@and, :@BEGIN, :@begin, :@break, :@case, :@class, :@def, :@defined, 
                         :@do, :@else, :@elsif, :@END, :@end, :@ensure, :@false, :@for, :@if, :@in, 
                         :@module, :@next, :@nil, :@not, :@or, :@redo, :@rescue, :@retry, :@return, 
                         :@self, :@super, :@then, :@true, :@undef, :@unless, :@until, :@when, :@while, 
                         :@yield]
                         
    SEPARATORS        = [:@semicolon, :@comma, :'@::']
    
    UNARY_OPERATORS   = [:'@+', :'@-', :'@!', :'@~', :@not]
    BINARY_OPERATORS  = [:'@**', :'@*', :'@/', :'@%', :'@+', :'@-', :'@<<', :'@>>', :'@&', :'@|', :'@^', 
                         :'@>', :'@>=', :'@<', :'@<=', :'@<=>', :'@==', :'@===', :'@!=', :'@=~', :'@!~', 
                         :'@&&', :'@||', :@and, :@or]
    TERNARY_OPERATORS = [:'@?', :'@:']
    ASSIGN_OPERATORS  = [:'@=', :'@+=', :'@-=', :'@*=', :'@**=', :'@%=', :'@/=', :'@|=', :'@&=', :'@^=', 
                         :'@[]=', :'@||=', :'@&&=', :'@<<=', :'@>>=']
    ACCESS_OPERATORS  = [:'@[]']

    OPERATORS = UNARY_OPERATORS + BINARY_OPERATORS + TERNARY_OPERATORS + ASSIGN_OPERATORS + ACCESS_OPERATORS


    include Lexer, Statements, Const, Method, Call, Block, Args, Assignment, Operator,
            If, Case, For, While, Identifier, Literal, String, Symbol, Array, Hash

    attr_reader :src, :filename, :stack, :tstring_stack, :trailing_whitespace

    def initialize(src, filename = nil, lineno = nil)
      @src = src ||= filename && File.read(filename) || ''
      @src.gsub!(/([\s\n]*)\Z/) { |s| @trailing_whitespace = Ruby::Whitespace.new(s) and nil }

      @filename = filename
      @stack = []
      @stack = Stack.new
      @tstring_stack = []

      super
    end

    protected

      def position
        Ruby::Node::Position.new(lineno - 1, column)
      end

      def push(sexp = nil)
        token = Token.new(*sexp) if sexp
        stack.push(token) unless extra_heredoc_chars(token)
        token
      end

      def pop(*args)
        options = args.last.is_a?(::Hash) ? args.pop : {}
        if types = options[:ignore]
          stack_ignore(types) { stack.pop(*args << options) }
        else
          stack.pop(*args << options)
        end
      end
      
      def shift(*args)
        stack.reverse!
        result = pop(*args)
        stack.reverse!
        result
      end
      
      def pop_one(*types)
        options = types.last.is_a?(::Hash) ? types.pop : {}
        options[:max] = 1
        pop(*types << options).first
      end
      
      def pop_token(*types)
        options = types.last.is_a?(::Hash) ? types.pop : {}
        options[:max] = 1
        pop_tokens(*types << options).first
      end
      
      def shift_token(*types)
        options = types.last.is_a?(::Hash) ? types.pop : {}
        options[:max] = 1
        shift_tokens(*types << options).first
      end

      def pop_tokens(*types)
        pop(*types).map { |token| build_token(token) }.flatten.compact
      end

      def shift_tokens(*types)
        shift(*types).map { |token| build_token(token) }.flatten.compact
      end
      
      def pop_identifier(type, options = {})
        pop_token(type, options).to_identifier
      end
      
      def pop_operator(options = {})
        pop_token(*OPERATORS, options)
      end
      
      def pop_unary_operator(options = {})
        pop_token(*UNARY_OPERATORS, options)
      end

      def pop_binary_operator(options = {})
        pop_token(*BINARY_OPERATORS, options)
      end

      def pop_ternary_operators(options = {})
        pop_tokens(*TERNARY_OPERATORS, options)
      end

      def pop_ternary_operator(options = {})
        pop_token(*TERNARY_OPERATORS, options)
      end

      def pop_assignment_operator(options = {})
        pop_token(*ASSIGN_OPERATORS, options)
      end

      def pop_context
        stack.context.get
      end

      def stack_ignore(*types, &block)
        stack.ignore_types(*types, &block)
      end
      
      def build_token(token)
        Ruby::Token.new(token.value, token.position, token.context) if token
      end

      def extract_src(from, to)
        # TODO make Clip work with start/end positions and use it
        lines = Ruby::Node::Text.split(src)
        lines[from.row] = lines[from.row][from.col..-1] # || ''
        lines[to.row] = lines[to.row][0, to.col]
        lines[from.row..to.row].join
      end
  end
end