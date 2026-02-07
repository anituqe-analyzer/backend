class AuctionImage < ApplicationRecord
  belongs_to :auction

  validates :image_url, presence: true
  
  # Allowlist of attributes Ransack is allowed to search on
  def self.ransackable_attributes(auth_object = nil)
    ["id", "auction_id", "image_url", "deleted", "created_at", "updated_at"]
  end
end
