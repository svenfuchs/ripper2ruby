require 'ruby/identifier'

module Ruby
  class ParamsList < Node # join with ArgsList?
    child_accessor :params, :separators, :ldelim, :rdelim

    def initialize(params, whitespace, ldelim, rdelim, separators)
      self.ldelim = ldelim
      self.rdelim = rdelim
      self.separators = separators
      self.params = params
    end

    def nodes
      [ldelim, zip(separators), rdelim].flatten.compact
    end

    def method_missing(method, *args, &block)
      @params.respond_to?(method) ? @params.send(method, *args, &block) : super
    end
  end

  class RestParam < Identifier
    child_accessor :ldelim

    def initialize(token, position, ldelim)
      self.ldelim = ldelim
      super(token, ldelim.position)
    end

    def to_ruby(include_whitespace = false)
      ldelim.to_ruby(include_whitespace) + super(true)
    end
  end
end