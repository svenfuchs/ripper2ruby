class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Case
      def on_case(args, when_block)
        rdelim = pop_token(:@end)
        separators = pop_tokens(:@semicolon)
        ldelim = pop_token(:@case)

        args = Ruby::Statements.new(args) unless args.is_a?(Ruby::Statements)
        args = Ruby::Statements.new(args, separators) unless separators.empty?

        Ruby::Case.new(args, when_block, ldelim, rdelim)
      end
      
      def on_when(expression, statements, next_block)
        rdelim = pop_token(:@then)
        # separators = pop_tokens(:@semicolon)
        ldelim = pop_token(:@when)
        
        # expression = Ruby::Statements.new(expression, separators) unless separators.empty?

        Ruby::When.new(expression, Ruby::Block.new(statements), next_block, ldelim, rdelim)
      end
    end
  end
end