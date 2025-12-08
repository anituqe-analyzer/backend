class CreateOpinionVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :opinion_votes do |t|
      t.references :opinion, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :vote_type

      t.timestamps
    end
    add_index :opinion_votes, [ :opinion_id, :user_id ], unique: true
  end
end
