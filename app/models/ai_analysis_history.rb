class AiAnalysisHistory < ApplicationRecord
  belongs_to :auction

  serialize :ai_raw_result, coder: JSON

  enum :ai_decision, {
    authentic: "authentic",
    fake: "fake",
    uncertain: "uncertain"
  }
end
