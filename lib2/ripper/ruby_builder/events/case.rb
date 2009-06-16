class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Case
      def on_case(args, when_block)
        rdelim = pop_delim(:@kw, :value => 'end')
        separators = pop_delims(:@semicolon)
        ldelim = pop_delim(:@kw, :value => 'case')

        args = Ruby::Statements.new(args) unless args.is_a?(Ruby::Statements)
        args = Ruby::Statements.new(args, separators) unless separators.empty?

        Ruby::Case.new(args, when_block, ldelim, rdelim)
      end
      
      def on_when(expression, statements, next_block)
        rdelim = stack_ignore(:@kw, :value => 'end') { pop_delim(:@kw, :value => 'then') }
        # separators = stack_ignore(:@kw, :value => 'end') { pop_delims(:@semicolon) }
        ldelim = stack_ignore(:@kw, :value => 'end') { pop_delim(:@kw, :value => 'when') }
        
        # expression = Ruby::Statements.new(expression, separators) unless separators.empty?

        Ruby::When.new(expression, Ruby::Block.new(statements), next_block, ldelim, rdelim)
      end
    end
  end
end