class ImageAnalysis < ApplicationRecord
  belongs_to :blob, class_name: "ActiveStorage::Blob"

  serialize :ai_detected_features, coder: JSON

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "blob_id", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "blob" ]
  end
end
