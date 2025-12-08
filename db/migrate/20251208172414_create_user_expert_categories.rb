class CreateUserExpertCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :user_expert_categories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :user_expert_categories, [ :user_id, :category_id ], unique: true, name: 'index_user_categories_on_user_and_category'
  end
end
