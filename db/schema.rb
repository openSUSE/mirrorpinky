# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131015121651) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "country", force: true do |t|
    t.string "code", limit: 2,  null: false
    t.string "name", limit: 64, null: false
  end

  create_table "filearr", force: true do |t|
    t.string  "path",     limit: 512, null: false
    t.integer "mirrors",  limit: 2,                array: true
    t.string  "dirname",  limit: 512
    t.string  "filename", limit: 512
  end

  add_index "filearr", ["dirname"], name: "filearr_dirname_btree", using: :btree
  add_index "filearr", ["path"], name: "filearr_path_key", unique: true, using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_server", force: true do |t|
    t.integer "group_id"
    t.integer "server_id"
  end

  create_table "groups_users", force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "hash", id: false, force: true do |t|
    t.integer "file_id",                 null: false
    t.integer "mtime",                   null: false
    t.integer "size",          limit: 8, null: false
    t.binary  "md5",                     null: false
    t.binary  "sha1",                    null: false
    t.binary  "sha256",                  null: false
    t.integer "sha1piecesize",           null: false
    t.binary  "sha1pieces",              null: false
    t.binary  "btih",                    null: false
    t.text    "pgp",                     null: false
    t.integer "zblocksize",    limit: 2, null: false
    t.string  "zhashlens",     limit: 8
    t.binary  "zsums",                   null: false
  end

  create_table "marker", force: true do |t|
    t.string "subtree_name", limit: 128, null: false
    t.string "markers",      limit: 512, null: false
  end

# Could not dump table "pfx2asn" because of following StandardError
#   Unknown type 'ip4r' for column 'pfx'

  create_table "region", force: true do |t|
    t.string "code", limit: 2,  null: false
    t.string "name", limit: 64, null: false
  end

  create_table "roles", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["title"], name: "index_roles_on_title", using: :btree

  create_table "rsync_acls", force: true do |t|
    t.string   "host"
    t.integer  "server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rsync_acls", ["server_id"], name: "index_rsync_acls_on_server_id", using: :btree

  create_table "server", force: true do |t|
    t.string   "identifier",      limit: 64,                                          null: false
    t.string   "baseurl",         limit: 128,                                         null: false
    t.string   "baseurl_ftp",     limit: 128,                                         null: false
    t.string   "baseurl_rsync",   limit: 128,                                         null: false
    t.boolean  "enabled",                                                             null: false
    t.boolean  "status_baseurl",                                                      null: false
    t.string   "region",          limit: 2,                                           null: false
    t.string   "country",         limit: 2,                                           null: false
    t.integer  "asn",                                                                 null: false
    t.string   "prefix",          limit: 18,                                          null: false
    t.boolean  "ipv6_only",                                           default: false, null: false
    t.integer  "score",           limit: 2,                                           null: false
    t.integer  "scan_fpm",                                                            null: false
    t.datetime "last_scan"
    t.text     "comment",                                                             null: false
    t.string   "operator_name",   limit: 128,                                         null: false
    t.string   "operator_url",    limit: 128,                                         null: false
    t.string   "public_notes",    limit: 512,                                         null: false
    t.string   "admin",           limit: 128,                                         null: false
    t.string   "admin_email",     limit: 128,                                         null: false
    t.decimal  "lat",                         precision: 6, scale: 3
    t.decimal  "lng",                         precision: 6, scale: 3
    t.boolean  "country_only",                                                        null: false
    t.boolean  "region_only",                                                         null: false
    t.boolean  "as_only",                                                             null: false
    t.boolean  "prefix_only",                                                         null: false
    t.string   "other_countries", limit: 512,                                         null: false
    t.integer  "file_maxsize",                                        default: 0,     null: false
  end

  add_index "server", ["enabled", "status_baseurl", "score"], name: "server_enabled_status_baseurl_score_key", using: :btree
  add_index "server", ["identifier"], name: "server_identifier_key", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password", limit: 128
    t.string   "salt",               limit: 128
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.integer  "role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "users_groups", force: true do |t|
    t.integer "users_id"
    t.integer "groups_id"
  end

  add_index "users_groups", ["groups_id"], name: "index_users_groups_on_groups_id", using: :btree
  add_index "users_groups", ["users_id"], name: "index_users_groups_on_users_id", using: :btree

  create_table "version", id: false, force: true do |t|
    t.text    "component",  null: false
    t.integer "major",      null: false
    t.integer "minor",      null: false
    t.integer "patchlevel", null: false
  end

end
