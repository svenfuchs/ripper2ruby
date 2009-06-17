class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Assignment
      # simple assignments, e.g. a = b
      def on_assign(left, right)
        Ruby::Assignment.new(left, right, pop_token(:'@=', :pass => true))
      end

      # mass assignments, e.g. a, b = c, d
      def on_massign(left, right)
        Ruby::Assignment.new(left, right, pop_token(:'@=', :pass => true))
      end
      
      # operator assignment (?), e.g. a ||= b; a += 1
      def on_opassign(left, operator, right)
        Ruby::Assignment.new(left, right, pop_token(:@op, :value => operator.value, :pass => true))
      end

      def on_mlhs_new
        Ruby::MultiAssignment.new(:left, nil, nil, pop_token(:@lparen))
      end

      def on_mlhs_add(assignment, ref)
        separator = pop_token(:@comma)
        assignment.separators << separator if separator
        assignment << ref
        assignment
      end

      def on_mlhs_paren(arg)
        arg.rdelim = pop_token(:@rparen) if arg.is_a?(Ruby::MultiAssignment)
        arg
      end

      def on_mrhs_new
        separators = pop_tokens(:@comma).reverse
        star = pop_token(:'@*')
        Ruby::MultiAssignment.new(:right, nil, separators, nil, nil, star)
      end

      def on_mrhs_new_from_args(args)
        Ruby::MultiAssignment.new(:right, args.elements, args.separators)
      end

      def on_mrhs_add(assignment, ref)
        assignment << ref
        assignment
      end

      def on_mrhs_add_star(assignment, ref)
        assignment << ref
        assignment
      end
    end
  end
end