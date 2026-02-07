class Opinion < ApplicationRecord
  belongs_to :auction
  belongs_to :user
  has_many :opinion_votes, dependent: :destroy

  enum :author_type, {
    user: "user",
    expert: "expert"
  }

  enum :verdict, {
    authentic: "authentic",
    fake: "fake",
    unsure: "unsure"
  }

  validates :content, presence: true
  validates :author_type, presence: true

  def update_score!
    update(score: opinion_votes.sum(:vote_type))
  end

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "content", "author_type", "verdict", "score", "auction_id", "user_id", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "auction", "user", "opinion_votes" ]
  end
end
