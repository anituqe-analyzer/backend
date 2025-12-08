class AiAnalysisHistory < ApplicationRecord
  belongs_to :auction

  serialize :ai_raw_result, coder: JSON

  enum :ai_decision, {
    authentic: "authentic",
    fake: "fake",
    uncertain: "uncertain"
  }

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "auction_id", "model_version", "ai_score_authenticity", "ai_decision", "message", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "auction" ]
  end
end
