class Auction < ApplicationRecord
  belongs_to :submitted_by_user, class_name: "User"
  belongs_to :category
  has_many_attached :images
  has_many :opinions, dependent: :destroy
  has_many :ai_analysis_histories, dependent: :destroy
  has_many :auction_images, dependent: :destroy

  enum :verification_status, {
    pending: "pending",
    ai_verified: "ai_verified",
    expert_verified: "expert_verified",
    disputed: "disputed",
    fake: "fake"
  }, default: "pending"

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :currency, presence: true
  validates :verification_status, presence: true

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "title", "description_text", "price", "currency", "verification_status", "external_link", "ai_score_authenticity", "ai_uncertainty_message", "submitted_by_user_id", "category_id", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "category", "submitted_by_user", "opinions", "ai_analysis_histories", "images_attachments", "images_blobs", "auction_images" ]
  end
end
