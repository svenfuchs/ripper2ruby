class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Assignment
      # simple assignments, e.g. a = b
      def on_assign(left, right)
        Ruby::Assignment.new(left, right, pop_delim(:@op, :value => '='))
      end

      # mass assignments, e.g. a, b = c, d
      def on_massign(left, right)
        Ruby::Assignment.new(left, right, pop_delim(:@op, :value => '='))
      end

      def on_mlhs_new
        Ruby::MultiAssignment.new(:left, pop_delim(:@lparen))
      end

      def on_mlhs_add(assignment, ref)
        separator = pop_delim(:@comma)
        assignment.separators << separator if separator
        assignment << ref
        assignment
      end

      def on_mlhs_paren(arg)
        arg.rdelim = pop_delim(:@rparen) if arg.is_a?(Ruby::MultiAssignment)
        arg
      end

      def on_mrhs_new
        separators = pop_delims(:@comma).reverse
        star = pop_delim(:@op, :value => '*')
        Ruby::MultiAssignment.new(:right, nil, nil, separators, star)
      end

      def on_mrhs_new_from_args(args)
        Ruby::MultiAssignment.new(:right, nil, nil, args.separators, nil, args.elements)
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