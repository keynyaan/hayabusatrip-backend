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

ActiveRecord::Schema[7.0].define(version: 2023_07_27_084758) do
  create_table "prefectures", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "image_path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spots", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.string "category", default: "sightseeing", null: false
    t.string "name", limit: 30, null: false
    t.date "date", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.integer "cost", default: 0, null: false
    t.string "memo", limit: 50, default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_spots_on_trip_id"
  end

  create_table "trips", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "prefecture_id", null: false
    t.string "title", limit: 30, null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.string "memo", limit: 1000, default: "", null: false
    t.string "image_path", null: false
    t.boolean "is_public", default: false, null: false
    t.string "trip_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prefecture_id"], name: "index_trips_on_prefecture_id"
    t.index ["trip_token"], name: "index_trips_on_trip_token", unique: true
    t.index ["user_id"], name: "index_trips_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 20, default: "新規ユーザー", null: false
    t.string "icon_path", default: "/images/default-user-icon.png", null: false
    t.datetime "last_login_time"
  end

  add_foreign_key "spots", "trips"
  add_foreign_key "trips", "prefectures"
  add_foreign_key "trips", "users"
end
