class NullUser

  def id; end
  def name; end
  def password; end

  def authenticate(*)
    false
  end

end
