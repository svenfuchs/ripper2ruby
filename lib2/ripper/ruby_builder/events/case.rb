class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Case
      def on_case(args, when_block)
        rdelim = pop_token(:@end)
        separators = pop_tokens(:@semicolon)
        identifier = pop_token(:@case)

        args = Ruby::Statements.new(args) unless args.is_a?(Ruby::Statements)
        args = Ruby::Statements.new(args, separators) unless separators.empty?

        Ruby::Case.new(identifier, args, when_block, rdelim)
      end
      
      def on_when(expression, statements, next_block)
        ldelim = pop_token(:@then)
        identifier = pop_token(:@when)
        # separators = pop_tokens(:@semicolon)
        # expression = Ruby::Statements.new(expression, separators) unless separators.empty?

        Ruby::When.new(identifier, expression, statements, ldelim, next_block)
      end
    end
  end
end