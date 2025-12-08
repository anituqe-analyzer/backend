class Auction < ApplicationRecord
  belongs_to :submitted_by_user, class_name: "User"
  belongs_to :category
  has_many_attached :images
  has_many :opinions, dependent: :destroy
  has_many :ai_analysis_histories, dependent: :destroy

  enum verification_status: {
    pending: "pending",
    ai_verified: "ai_verified",
    expert_verified: "expert_verified",
    disputed: "disputed",
    fake: "fake"
  }

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :currency, presence: true
  validates :verification_status, presence: true
end
