class User < ApplicationRecord
  has_secure_password

  has_many :auctions, foreign_key: "submitted_by_user_id", dependent: :destroy
  has_many :opinions, dependent: :destroy
  has_many :opinion_votes, dependent: :destroy
  has_many :user_expert_categories, dependent: :destroy
  has_many :expert_categories, through: :user_expert_categories, source: :category

  enum :role, {
    user: "user",
    expert: "expert",
    admin: "admin"
  }, default: "user"

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true
end
