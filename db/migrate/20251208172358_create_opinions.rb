class CreateOpinions < ActiveRecord::Migration[8.1]
  def change
    create_table :opinions do |t|
      t.references :auction, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :author_type, null: false
      t.text :content, null: false
      t.string :verdict, null: false
      t.integer :score, default: 0

      t.timestamps
    end
    add_index :opinions, [ :auction_id, :user_id ]
  end
end
