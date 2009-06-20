class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Hash
      def on_hash(assocs)
        rdelim = pop_token(:@rbrace)
        # , :pass => true ... won't work with nested hashes / dangling commas
        separators = assocs ? pop_tokens(:@comma, :max => assocs.length, :right => rdelim).reverse : nil
        ldelim = pop_token(:@lbrace)
        Ruby::Hash.new(assocs, separators, ldelim, rdelim)
      end

      def on_assoclist_from_args(args)
        args
      end

      def on_bare_assoc_hash(assocs)
        separators = assocs ? pop_tokens(:@comma, :max => assocs.length - 1, :pass => true, :right => assocs.last).reverse : nil
        Ruby::Hash.new(assocs, separators)
      end

      def on_assoc_new(key, value)
        Ruby::Assoc.new(key, value, pop_token(:'@=>'))
      end
    end
  end
end

