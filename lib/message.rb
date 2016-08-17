class Message
  def self.login_success
    "Login successful"
  end

  def self.login_failed
    "Incorrect username or password"
  end

  def self.logout_success
    "Logout successful"
  end

  def self.invalid_token
    "Invalid token signature"
  end

  def self.no_bucket
    "No BucketList Found"
  end

  def self.invalid_bucket
    "Bucket List Not found"
  end

  def self.unauthenticated
    "Unauthenticated User"
  end

  def self.no_item
    "Item not found"
  end
end
