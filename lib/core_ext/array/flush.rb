class Array
  def flush
    self.dup.tap { self.clear }
  end
end