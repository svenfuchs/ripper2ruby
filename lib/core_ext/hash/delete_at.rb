class Hash
  def delete_at(*keys)
    keys.map { |key| delete(key) }
  end
end