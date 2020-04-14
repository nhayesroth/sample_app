class User < ApplicationRecord

  attr_accessor(:remember_token)

  before_save { self.email = email.downcase }
  validates(
    :name,
    {
      presence: true,
      length: { maximum: 99 }
    })
  validates(
    :email,
    {
      presence: true,
      length: { maximum: 99 },
      format: { with: /\A[\w+\-.]+@([a-z\d\-]+\.)+[a-z]+\z/i },
      uniqueness: { case_sensitive: false }
    })
  validates(
    :password,
    {
      presence: true,
      length: { minimum: 5 },
    })
  has_secure_password

  #  Class method that computes the secure hash transformation of a given string (password)
  def User.digest(string)
    # Use the minimum cost in tests and a normal (high) cost in production
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    return BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token()
    return SecureRandom.urlsafe_base64();
  end

  # Generates a new remember_digest to remember this user (i.e. when they login).
  # Returns the corresponding remember_token for use in cookies.
  def update_remember_digest()
    remember_token = User.new_token();
    update_attribute(:remember_digest, User.digest(remember_token));
    return remember_token
  end

  # Wipes the remember_digest for this user (i.e. when they logout.)
  def forget_remember_digest()
    update_attribute(:remember_digest, nil);
    return self;
  end

  # Returns whether the specified remember_token matches the stored digest
  def authenticated?(signed_remember_token)
    return BCrypt::Password.new(remember_digest).is_password?(signed_remember_token)
  end
end
