class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Case
      def on_case(expression, when_block)
        ldelim, rdelim = pop_delims(:@kw, :value => %w(case end)).reverse
        Ruby::Case.new(expression, when_block, ldelim, rdelim)
      end
      
      def on_when(expression, statements, next_block)
        rdelim = stack_ignore(:@kw, :value => 'end') { pop_delim(:@kw, :value => 'then') }
        ldelim = stack_ignore(:@kw, :value => 'end') { pop_delim(:@kw, :value => 'when') }
        Ruby::When.new(expression, Ruby::Block.new(statements), next_block, ldelim, rdelim)
      end
    end
  end
end