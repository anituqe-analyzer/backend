class CreateAuctionImages < ActiveRecord::Migration[8.1]
  def change
    create_table :auction_images do |t|
      t.references :auction, null: false, foreign_key: true
      t.string :image_url
      t.boolean :deleted, default: false, null: false

      t.timestamps
    end
  end
end
