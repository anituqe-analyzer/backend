class CreateAuctions < ActiveRecord::Migration[8.1]
  def change
    create_table :auctions do |t|
      t.references :submitted_by_user, null: false, foreign_key: { to_table: :users }
      t.string :external_link
      t.string :title, null: false
      t.text :description_text
      t.decimal :price, precision: 10, scale: 2
      t.string :currency, default: 'PLN'
      t.references :category, null: false, foreign_key: true
      t.string :verification_status, default: 'pending'
      t.float :ai_score_authenticity
      t.text :ai_uncertainty_message

      t.timestamps
    end
    add_index :auctions, :verification_status
  end
end
