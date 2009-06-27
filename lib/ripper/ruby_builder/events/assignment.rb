class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Assignment
      def on_assign(left, right)
        Ruby::Assignment.new(left, right, pop_token(:'@='))
      end

      def on_massign(left, right)
        Ruby::Assignment.new(left, right, pop_token(:'@='))
      end
      
      def on_opassign(left, operator, right)
        Ruby::Assignment.new(left, right, pop_assignment_operator)
      end

      def on_mlhs_new
        Ruby::MultiAssignment.new(:left, nil, pop_token(:@lparen))
      end

      def on_mlhs_add(assignment, ref)
        assignment << ref
        assignment
      end

      def on_mlhs_paren(arg)
        arg.rdelim ||= pop_token(:@rparen) if arg.respond_to?(:rdelim)
        arg.ldelim ||= pop_token(:@lparen) if arg.respond_to?(:ldelim)
        arg
      end

      def on_mrhs_new
        Ruby::MultiAssignment.new(:right, nil)
      end

      def on_mrhs_new_from_args(args)
        Ruby::MultiAssignment.new(:right, args.elements)
      end

      def on_mrhs_add(assignment, ref)
        assignment << ref
        assignment
      end

      def on_mlhs_add_star(assignment, ref)
        assignment << Ruby::Arg.new(ref, pop_token(:'@*'))
        assignment
      end

      def on_mrhs_add_star(assignment, ref)
        assignment << Ruby::Arg.new(ref, pop_token(:'@*'))
        assignment
      end
    end
  end
end
