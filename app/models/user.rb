class User < ApplicationRecord
  has_secure_password

  enum role: {
    user: "user",
    expert: "expert",
    admin: "admin"
  }

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true
end
