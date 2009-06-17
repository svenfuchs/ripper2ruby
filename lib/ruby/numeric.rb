module Ruby
  class Integer < Token
    def value
      token.to_i
    end
  end

  class Float < Token
    def value
      token.to_f
    end
  end
end