class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module For
      def on_for(variable, range, statements)
        rdelim   = pop_token(:@kw, :value => 'end')
        operator = pop_token(:@kw, :value => 'in')
        ldelim   = pop_token(:@kw, :value => 'for')
        Ruby::For.new(statements, variable, operator, range, ldelim, rdelim)
      end
      
      # def on_until(expression, statements)
      #   rdelim = pop_token(:@kw, :value => 'end')
      #   ldelim = pop_token(:@kw, :value => 'until')
      #   Ruby::Until.new(expression, statements, ldelim, rdelim)
      # end
      # 
      # def on_while_mod(expression, statement)
      #   Ruby::WhileMod.new(expression, statement, pop_token(:@kw, :value => 'while'))
      # end
      # 
      # def on_until_mod(expression, statement)
      #   Ruby::UntilMod.new(expression, statement, pop_token(:@kw, :value => 'until'))
      # end
    end
  end
end