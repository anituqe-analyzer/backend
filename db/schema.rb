# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_08_172421) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ai_analysis_histories", force: :cascade do |t|
    t.string "ai_decision"
    t.text "ai_raw_result"
    t.float "ai_score_authenticity"
    t.integer "auction_id", null: false
    t.datetime "created_at", null: false
    t.text "message"
    t.string "model_version"
    t.datetime "updated_at", null: false
    t.index ["auction_id"], name: "index_ai_analysis_histories_on_auction_id"
  end

  create_table "auctions", force: :cascade do |t|
    t.float "ai_score_authenticity"
    t.text "ai_uncertainty_message"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "PLN"
    t.text "description_text"
    t.string "external_link"
    t.decimal "price", precision: 10, scale: 2
    t.integer "submitted_by_user_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "verification_status", default: "pending"
    t.index ["category_id"], name: "index_auctions_on_category_id"
    t.index ["submitted_by_user_id"], name: "index_auctions_on_submitted_by_user_id"
    t.index ["verification_status"], name: "index_auctions_on_verification_status"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.integer "parent_id"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "image_analyses", force: :cascade do |t|
    t.text "ai_detected_features"
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blob_id"], name: "index_image_analyses_on_blob_id"
  end

  create_table "opinion_votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "opinion_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "vote_type"
    t.index ["opinion_id", "user_id"], name: "index_opinion_votes_on_opinion_id_and_user_id", unique: true
    t.index ["opinion_id"], name: "index_opinion_votes_on_opinion_id"
    t.index ["user_id"], name: "index_opinion_votes_on_user_id"
  end

  create_table "opinions", force: :cascade do |t|
    t.integer "auction_id", null: false
    t.string "author_type", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.integer "score", default: 0
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "verdict", null: false
    t.index ["auction_id", "user_id"], name: "index_opinions_on_auction_id_and_user_id"
    t.index ["auction_id"], name: "index_opinions_on_auction_id"
    t.index ["user_id"], name: "index_opinions_on_user_id"
  end

  create_table "user_expert_categories", force: :cascade do |t|
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["category_id"], name: "index_user_expert_categories_on_category_id"
    t.index ["user_id", "category_id"], name: "index_user_categories_on_user_and_category", unique: true
    t.index ["user_id"], name: "index_user_expert_categories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "role", default: "user"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ai_analysis_histories", "auctions"
  add_foreign_key "auctions", "categories"
  add_foreign_key "auctions", "users", column: "submitted_by_user_id"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "image_analyses", "active_storage_blobs", column: "blob_id"
  add_foreign_key "opinion_votes", "opinions"
  add_foreign_key "opinion_votes", "users"
  add_foreign_key "opinions", "auctions"
  add_foreign_key "opinions", "users"
  add_foreign_key "user_expert_categories", "categories"
  add_foreign_key "user_expert_categories", "users"
end
