class Opinion < ApplicationRecord
  belongs_to :auction
  belongs_to :user
  has_many :opinion_votes, dependent: :destroy

  enum author_type: {
    user: "user",
    expert: "expert"
  }

  enum verdict: {
    authentic: "authentic",
    fake: "fake",
    unsure: "unsure"
  }

  validates :content, presence: true
  validates :author_type, presence: true
  validates :verdict, presence: true

  def update_score!
    update(score: opinion_votes.sum(:vote_type))
  end
end
