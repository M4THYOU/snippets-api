# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_27_213704) do

  create_table "courses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "code_UNIQUE", unique: true
  end

  create_table "lessons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.string "course", null: false
    t.text "canvas", null: false
    t.integer "created_by_uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "snippet_id", null: false
    t.text "text", null: false
    t.integer "created_by_uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "search_indices", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "word", limit: 128, null: false
    t.integer "snippet_id", null: false
    t.integer "weight", default: 0, null: false
    t.index ["word", "snippet_id"], name: "unique_index", unique: true
  end

  create_table "snippets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.string "snippet_type", null: false
    t.string "course", null: false
    t.text "raw", null: false
    t.integer "created_by_uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course"], name: "course_idx"
    t.index ["snippet_type"], name: "snippet_type_idx"
  end

  create_table "types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "name_UNIQUE", unique: true
  end

  create_table "u_group_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "group_type", limit: 32, null: false
    t.text "description", size: :medium
    t.integer "is_singular", limit: 1, comment: "Indicates if there can only be one active group of this type in the database."
    t.index ["group_type"], name: "group_type_UNIQUE", unique: true
  end

  create_table "u_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "group_type", limit: 32, null: false
    t.text "description", size: :medium
    t.datetime "created_on", default: -> { "CURRENT_TIMESTAMP" }
    t.integer "created_by_uid"
    t.index ["group_type"], name: "group_type_idx"
  end

  create_table "u_role_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "role_type", limit: 32, null: false, comment: "Lookup code for the role."
    t.string "name", limit: 64, comment: "Human-readable name for the type (does not have to indicate test context)."
    t.text "description", size: :medium, comment: "Brief description of the role."
    t.integer "is_singular", limit: 1, comment: "Identifies roles which are intended to only be assigned to one member in a group."
    t.index ["role_type"], name: "role_type_UNIQUE", unique: true
  end

  create_table "u_roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "role_type", limit: 45, null: false
    t.integer "uid", null: false
    t.integer "group_id", null: false
    t.datetime "created_on", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "created_by_uid", null: false
    t.datetime "expires_on"
    t.integer "is_revoked", default: 0
    t.datetime "revoked_on"
    t.integer "revoked_by_uid"
    t.index ["group_id"], name: "group_id_idx"
    t.index ["role_type"], name: "role_type_idx"
    t.index ["uid"], name: "uid_idx"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "snippets", "courses", column: "course", primary_key: "code", name: "course"
  add_foreign_key "snippets", "types", column: "snippet_type", primary_key: "name", name: "snippet_type"
  add_foreign_key "u_groups", "u_group_types", column: "group_type", primary_key: "group_type", name: "group_type"
  add_foreign_key "u_roles", "u_groups", column: "group_id", name: "group_id"
  add_foreign_key "u_roles", "u_role_types", column: "role_type", primary_key: "role_type", name: "role_type"
  add_foreign_key "u_roles", "users", column: "uid", name: "uid"
end
