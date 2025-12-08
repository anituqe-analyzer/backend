class ImageAnalysis < ApplicationRecord
  belongs_to :blob, class_name: "ActiveStorage::Blob"

  serialize :ai_detected_features, coder: JSON
end
