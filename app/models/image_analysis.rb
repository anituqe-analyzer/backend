class ImageAnalysis < ApplicationRecord
  belongs_to :auction

  serialize :ai_detected_features, JSON
  serialize :image_urls, Array

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "auction_id", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "auction" ]
  end
end
