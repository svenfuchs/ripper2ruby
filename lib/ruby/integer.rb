module Ruby
  class Integer < Identifier
    def value
      token.to_i
    end
  end
end