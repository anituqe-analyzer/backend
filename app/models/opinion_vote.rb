class OpinionVote < ApplicationRecord
  belongs_to :opinion
  belongs_to :user

  validates :vote_type, presence: true, inclusion: { in: [ -1, 1 ] }
  validates :user_id, uniqueness: { scope: :opinion_id }

  after_save :update_opinion_score
  after_destroy :update_opinion_score

  private

  def update_opinion_score
    opinion.update_score!
  end
end
