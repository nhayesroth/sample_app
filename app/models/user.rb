class User < ApplicationRecord
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
      uniqueness: true
    })
end
