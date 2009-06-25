class Object
  # alias_method :try, :__send__
  def try(method, *args, &block)
    send(method, *args, &block) if respond_to?(method)
  end
end

class NilClass
  def try(*args)
    nil
  end
end
