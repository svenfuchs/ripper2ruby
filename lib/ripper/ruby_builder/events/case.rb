class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Case
      def on_case(args, when_block)
        rdelim = pop_token(:@end)
        identifier = pop_token(:@case)
        Ruby::Case.new(identifier, args, when_block, rdelim)
      end
      
      def on_when(expression, statements, next_block)
        ldelim = pop_token(:@then)
        identifier = pop_token(:@when)
        Ruby::When.new(identifier, expression, statements, ldelim, next_block)
      end
    end
  end
end