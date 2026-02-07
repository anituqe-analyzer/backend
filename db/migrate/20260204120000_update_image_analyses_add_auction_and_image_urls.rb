class UpdateImageAnalysesAddAuctionAndImageUrls < ActiveRecord::Migration[8.1]
  def change
    # Remove ActiveStorage blob reference and add auction reference + image URLs
    remove_reference :image_analyses, :blob, foreign_key: { to_table: :active_storage_blobs }

    add_reference :image_analyses, :auction, null: false, foreign_key: true
    add_column :image_analyses, :image_urls, :text
  end
end
