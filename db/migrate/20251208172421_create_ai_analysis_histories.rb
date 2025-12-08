class CreateAiAnalysisHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :ai_analysis_histories do |t|
      t.references :auction, null: false, foreign_key: true
      t.string :model_version
      t.float :ai_score_authenticity
      t.text :ai_raw_result
      t.string :ai_decision
      t.text :message

      t.timestamps
    end
  end
end
