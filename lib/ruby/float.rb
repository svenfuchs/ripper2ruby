module Ruby
  class Float < Identifier
    def value
      token.to_f
    end
  end
end