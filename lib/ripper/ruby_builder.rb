require 'ripper'
require 'ruby'

require 'core_ext/hash/delete_at'
require 'core_ext/array/flush'

require 'ripper/ruby_builder/token'
require 'ripper/ruby_builder/stack'

require 'erb/stripper'

Dir[File.dirname(__FILE__) + '/ruby_builder/events/*.rb'].sort.each { |file| require file }

# Ripper::RubyBuilder extends Ripper's SexpBuilder and builds a rich, object
# oriented representation of Ruby code.
#
#   code = Ripper::RubyBuilder.build("foo(1, :bar, %w(baz)"), filename)
#   code.to_ruby # => "foo(1, :bar, %w(baz)"
#
# RubyBuilder uses SexpBuilder's lexing and parsing event callbacks (see
# ruby_builder/events) and builds up Ruby::Nodes which can then be used.
# See RubyBuilder::Stack, RubyBuilder::Queue, RubyBuilder::Buffer and
# RubyBuilder::Token for more details about the parsing process.

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class ParseError < RuntimeError
    end

    @@filters = [lambda { |src, file| file && File.extname(file) == '.erb' ? Erb::Stripper.new.to_ruby(src) : src }]

    class << self
      def build(src, filename = nil)
        new(src, filename).parse
      end

      def filters
        @@filters
      end
    end

    NEWLINE           = [:@nl, :@ignored_nl]
    WHITESPACE        = [:@sp, :@comment] + NEWLINE
    OPENERS           = [:@lparen, :@lbracket, :@lbrace, :@class, :@module, :@def, :@begin, :@while, :@until,
                         :@for, :@if, :@elsif, :@else, :@unless, :@case, :@when, :@embexpr_beg, :@do, :@rescue,
                         :'@=', :'@::']
    KEYWORDS          = [:@alias, :@and, :@BEGIN, :@begin, :@break, :@case, :@class, :@def, :@defined,
                         :@do, :@else, :@elsif, :@END, :@end, :@ensure, :@false, :@for, :@if, :@in,
                         :@module, :@next, :@nil, :@not, :@or, :@redo, :@rescue, :@retry, :@return,
                         :@self, :@super, :@then, :@true, :@undef, :@unless, :@until, :@when, :@while,
                         :@yield]

    SEPARATORS        = [:@semicolon, :@comma]

    UNARY_OPERATORS   = [:'@+', :'@-', :'@!', :'@~', :@not, :'@+@', :'@-@']
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

    attr_reader :src, :filename, :stack, :string_stack, :trailing_whitespace

    def initialize(src, filename = nil, lineno = nil)
      @src = src ||= filename && File.read(filename) || ''

      @filename = filename
      @stack = []
      @stack = Stack.new
      @string_stack = []

      src.gsub!(/([\s\n]*)\Z/) { |s| @trailing_whitespace = Ruby::Whitespace.new(s) and nil }
      src = filter(src, filename)

      super
    rescue ArgumentError => e
      p filename
      raise e
    end

    protected
      def filter(src, filename)
        self.class.filters.each { |filter| src = filter.call(src, filename) }
        src
      end

      def position
        Ruby::Node::Position.new(lineno.to_i - 1, column)
      end

      def prolog
        Ruby::Prolog.new(stack.buffer.flush)
      end

      def push(sexp = nil)
        token = Token.new(sexp[0], sexp[1], position) if sexp.is_a?(::Array)
        stack.push(token)
        token
      end

      def pop(*args)
        stack.pop(*args)
      end

      def pop_token(*types)
        options = types.last.is_a?(::Hash) ? types.pop : {}
        options[:max] = 1
        pop_tokens(*types << options).first
      end

      def pop_tokens(*types)
        pop(*types).map { |token| build_token(token) }.flatten.compact
      end

      def pop_identifier(type, options = {})
        pop_token(type, options).to_identifier
      end

      def pop_string_content
        pop_token(:@tstring_content).to_string_content
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

      def pop_ternary_operator(options = {})
        pop_token(*TERNARY_OPERATORS, options)
      end

      def pop_assignment_operator(options = {})
        pop_token(*ASSIGN_OPERATORS, options)
      end

      def pop_end_data
        token = pop_token(:@__end__)
        token.token = Ruby::Node::Text::Clip.new(src, token.position).to_s if token # TODO clean up
        token
      end

      def build_token(token)
        Ruby::Token.new(token.token, token.position, token.prolog) if token
      end

      def build_keyword(token)
        klass = Ruby.const_get(token.token[0].upcase + token.token[1..-1])
        klass.new(token, token.position, token.prolog)
      rescue NameError
        Ruby::Keyword.new(token, token.position, token.prolog)
      end

      def build_xstring(token)
        case token.type
        when :@symbeg
          Ruby::DynaSymbol.new(nil, build_token(token))
        when :@regexp_beg
          Ruby::Regexp.new(nil, build_token(token))
        else
          Ruby::ExecutableString.new(nil, build_token(token))
        end
      end
  end
end
