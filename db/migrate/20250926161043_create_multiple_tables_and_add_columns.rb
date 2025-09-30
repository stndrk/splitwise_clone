# frozen_string_literal: true

class CreateMultipleTablesAndAddColumns < ActiveRecord::Migration[6.1]
  def change
    #==============================*****CREATE GROUPS TABLE*****==============================
    create_table :groups do |t|
      t.string  :name, null: false
      t.text    :description
      t.boolean :active, default: true
      t.references :created_by, null: false, foreign_key: { to_table: :users } # who created this group
      t.references :admin, null: false, foreign_key: { to_table: :users } # who is the current admin (can be same as creator, or changed later)

      t.index :name
      t.index %i[name created_by_id], unique: true
      t.timestamps
    end

    #==============================*****CREATE GROUP MEMBERSHIPS TABLE*****==============================
    create_table :group_memberships do |t|
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end

    #==============================*****CREATE EXPENSES TABLE*****==============================
    create_table :expenses do |t|
      t.references :group, null: true, foreign_key: { to_table: :groups }
      t.references :paid_by, null: false, foreign_key: { to_table: :users }
      t.text    :description
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.decimal :tax, precision: 10, scale: 2, default: 0.0
      t.decimal :tip, precision: 10, scale: 2, default: 0.0
      t.string :split_type, null: false, default: "equal"

      t.timestamps
    end

    #==============================*****CREATE EXPENSE SPLITS TABLE*****==============================
    create_table :expense_splits do |t|
      t.references :expense, foreign_key: true
      t.references :user, foreign_key: true
      t.decimal :share

      t.timestamps
    end

    #==============================*****CREATE SETTLEMENTS TABLE*****==============================
    create_table :settlements do |t|
      t.references :from_user, null: false, foreign_key: { to_table: :users }
      t.references :to_user, null: false, foreign_key: { to_table: :users }
      t.references :group, foreign_key: true
      t.string :status
      t.text :description
      t.datetime :settled_at
      t.decimal :amount, precision: 10, scale: 2, null: false

      t.timestamps
    end

    #==============================*****CREATE PAYMENTS TABLE*****==============================
    create_table :payments do |t|
      t.references :paid_by, null: false, foreign_key: { to_table: :users }
      t.references :paid_to, null: false, foreign_key: { to_table: :users }
      t.string :status
      t.string :txn_id
      t.string :payment_mode
      t.text :description
      t.datetime :paid_at
      t.decimal :amount, precision: 10, scale: 2, null: false

      t.index :txn_id, unique: true
      t.timestamps
    end

    #==============================*****ADD COLUMN IN USER TABLE*****==============================
    add_column :users, :active, :boolean, default: true
  end
end
