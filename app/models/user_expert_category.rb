class UserExpertCategory < ApplicationRecord
  belongs_to :user
  belongs_to :category

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "user_id", "category_id", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user", "category" ]
  end
end
