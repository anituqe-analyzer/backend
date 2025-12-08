class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  has_many :auctions, dependent: :restrict_with_error
  has_many :user_expert_categories, dependent: :destroy
  has_many :experts, through: :user_expert_categories, source: :user

  validates :name, presence: true, uniqueness: true
end
