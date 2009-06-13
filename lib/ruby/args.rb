require 'ruby/node'

module Ruby
  class ArgsList < Node
    child_accessor :args, :separators, :ldelim, :rdelim

    def initialize
      self.args = []
      self.separators = []
    end
    
    def <<(arg)
      # unless arg.is_a?(Node)
      #   arg = from_native(arg, nil, ' ') 
      #   separators << from_native(' ,')
      # end
      super
    end
      
    def []=(ix, arg)
      arg = from_native(arg, nil, self[ix].whitespace) unless arg.is_a?(Node)
      arg.position = self[ix].position
      super
    end
    
    def pop
      [args.pop, separators.pop]
    end
    
    def options
      last.is_a?(Ruby::Hash) ? last : nil # TODO fix position!
    end
    
    def set_option(key, value)
      if options.nil?
        self << { key => value } 
      else
        options[key] = value
      end
    end
    
    def nodes
      [ldelim, zip(separators), rdelim].flatten.compact
    end

    def method_missing(method, *args, &block)
      self.args.respond_to?(method) ? self.args.send(method, *args, &block) : super
    end
  end

  class BlockArg < Node
    child_accessor :arg
    attr_accessor :ldelim
    
    def initialize(arg, ldelim)
      self.arg = arg
      self.ldelim = ldelim
    end
    
    def nodes
      [ldelim, arg]
    end
  end
end