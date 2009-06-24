class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Hash
      def on_hash(assocs)
        rdelim = pop_token(:@rbrace)
        ldelim = pop_token(:@lbrace)
        Ruby::Hash.new(assocs, ldelim, rdelim)
      end

      def on_assoclist_from_args(args)
        args
      end

      def on_bare_assoc_hash(assocs)
        Ruby::Hash.new(assocs)
      end

      def on_assoc_new(key, value)
        Ruby::Assoc.new(key, value, pop_token(:'@=>'))
      end
    end
  end
end

