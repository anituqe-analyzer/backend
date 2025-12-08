class CreateImageAnalyses < ActiveRecord::Migration[8.1]
  def change
    create_table :image_analyses do |t|
      t.references :blob, null: false, foreign_key: { to_table: :active_storage_blobs }
      t.text :ai_detected_features

      t.timestamps
    end
  end
end
