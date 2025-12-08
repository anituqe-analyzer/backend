class OpinionVote < ApplicationRecord
  belongs_to :opinion
  belongs_to :user

  validates :vote_type, presence: true, inclusion: { in: [ -1, 1 ] }
  validates :user_id, uniqueness: { scope: :opinion_id }

  after_save :update_opinion_score
  after_destroy :update_opinion_score

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "opinion_id", "user_id", "vote_type", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "opinion", "user" ]
  end

  private

  def update_opinion_score
    opinion.update_score!
  end
end
