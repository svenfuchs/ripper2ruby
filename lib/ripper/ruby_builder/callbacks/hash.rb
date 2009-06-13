class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Hash
      def on_hash(assocs)
        separators = pop_delims(:@rbrace, :@comma, :@lbrace).reverse
        ldelim, rdelim = separators.shift, separators.pop

        Ruby::Hash.new(assocs, ldelim, rdelim, separators)
      end

      def on_assoclist_from_args(args)
        args
      end

      def on_bare_assoc_hash(assocs)
        separators = stack_ignore(:@rparen) do 
          pop_delims(:@comma, :max => assocs.length - 1).reverse
        end
        
        Ruby::Hash.new(assocs, nil, nil, separators)
      end

      def on_assoc_new(key, value)
        stack_ignore(:@rbrace, :@rparen, :@comma) do
          assoc = Ruby::Assoc.new(key, value, pop_delim(:@op))
        end
      end
    end
  end
end

