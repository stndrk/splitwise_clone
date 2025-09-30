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

ActiveRecord::Schema.define(version: 2025_09_26_161043) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expense_splits", force: :cascade do |t|
    t.bigint "expense_id"
    t.bigint "user_id"
    t.decimal "share"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expense_id"], name: "index_expense_splits_on_expense_id"
    t.index ["user_id"], name: "index_expense_splits_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "paid_by_id", null: false
    t.text "description"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "tax", precision: 10, scale: 2, default: "0.0"
    t.decimal "tip", precision: 10, scale: 2, default: "0.0"
    t.string "split_type", default: "equal", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_expenses_on_group_id"
    t.index ["paid_by_id"], name: "index_expenses_on_paid_by_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "active", default: true
    t.bigint "created_by_id", null: false
    t.bigint "admin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_groups_on_admin_id"
    t.index ["created_by_id"], name: "index_groups_on_created_by_id"
    t.index ["name", "created_by_id"], name: "index_groups_on_name_and_created_by_id", unique: true
    t.index ["name"], name: "index_groups_on_name"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "paid_by_id", null: false
    t.bigint "paid_to_id", null: false
    t.string "status"
    t.string "txn_id"
    t.string "payment_mode"
    t.text "description"
    t.datetime "paid_at"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["paid_by_id"], name: "index_payments_on_paid_by_id"
    t.index ["paid_to_id"], name: "index_payments_on_paid_to_id"
    t.index ["txn_id"], name: "index_payments_on_txn_id", unique: true
  end

  create_table "settlements", force: :cascade do |t|
    t.bigint "from_user_id", null: false
    t.bigint "to_user_id", null: false
    t.bigint "group_id"
    t.string "status"
    t.text "description"
    t.datetime "settled_at"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_user_id"], name: "index_settlements_on_from_user_id"
    t.index ["group_id"], name: "index_settlements_on_group_id"
    t.index ["to_user_id"], name: "index_settlements_on_to_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "mobile_number"
    t.boolean "active", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "expense_splits", "expenses"
  add_foreign_key "expense_splits", "users"
  add_foreign_key "expenses", "groups"
  add_foreign_key "expenses", "users", column: "paid_by_id"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "groups", "users", column: "admin_id"
  add_foreign_key "groups", "users", column: "created_by_id"
  add_foreign_key "payments", "users", column: "paid_by_id"
  add_foreign_key "payments", "users", column: "paid_to_id"
  add_foreign_key "settlements", "groups"
  add_foreign_key "settlements", "users", column: "from_user_id"
  add_foreign_key "settlements", "users", column: "to_user_id"
end
