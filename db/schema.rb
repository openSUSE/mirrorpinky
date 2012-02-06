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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111205155313) do

  create_table "country", :force => true do |t|
    t.string "code", :limit => 2,  :null => false
    t.string "name", :limit => 64, :null => false
  end

  create_table "filearr", :force => true do |t|
    t.string "path",     :limit => 512, :null => false
    t.string "mirrors",  :limit => 2
    t.string "dirname",  :limit => 512
    t.string "filename", :limit => 512
  end

  add_index "filearr", ["dirname"], :name => "filearr_dirname_btree"
  add_index "filearr", ["path"], :name => "filearr_path_key", :unique => true

  create_table "hash", :id => false, :force => true do |t|
    t.integer "file_id",                    :null => false
    t.integer "mtime",                      :null => false
    t.integer "size",          :limit => 8, :null => false
    t.binary  "md5",                        :null => false
    t.binary  "sha1",                       :null => false
    t.binary  "sha256",                     :null => false
    t.integer "sha1piecesize",              :null => false
    t.binary  "sha1pieces",                 :null => false
    t.binary  "btih",                       :null => false
    t.text    "pgp",                        :null => false
    t.integer "zblocksize",    :limit => 2, :null => false
    t.string  "zhashlens",     :limit => 8
    t.binary  "zsums",                      :null => false
  end

  create_table "marker", :force => true do |t|
    t.string "subtree_name", :limit => 128, :null => false
    t.string "markers",      :limit => 512, :null => false
  end

# Could not dump table "pfx2asn" because of following StandardError
#   Unknown type 'ip4r' for column 'pfx'

  create_table "region", :force => true do |t|
    t.string "code", :limit => 2,  :null => false
    t.string "name", :limit => 64, :null => false
  end

  create_table "server", :force => true do |t|
    t.string   "identifier",      :limit => 64,                                               :null => false
    t.string   "baseurl",         :limit => 128,                                              :null => false
    t.string   "baseurl_ftp",     :limit => 128,                                              :null => false
    t.string   "baseurl_rsync",   :limit => 128,                                              :null => false
    t.boolean  "enabled",                                                                     :null => false
    t.boolean  "status_baseurl",                                                              :null => false
    t.string   "region",          :limit => 2,                                                :null => false
    t.string   "country",         :limit => 2,                                                :null => false
    t.integer  "asn",                                                                         :null => false
    t.string   "prefix",          :limit => 18,                                               :null => false
    t.integer  "score",           :limit => 2,                                                :null => false
    t.integer  "scan_fpm",                                                                    :null => false
    t.datetime "last_scan"
    t.text     "comment",                                                                     :null => false
    t.string   "operator_name",   :limit => 128,                                              :null => false
    t.string   "operator_url",    :limit => 128,                                              :null => false
    t.string   "public_notes",    :limit => 512,                                              :null => false
    t.string   "admin",           :limit => 128,                                              :null => false
    t.string   "admin_email",     :limit => 128,                                              :null => false
    t.decimal  "lat",                            :precision => 6, :scale => 3
    t.decimal  "lng",                            :precision => 6, :scale => 3
    t.boolean  "country_only",                                                                :null => false
    t.boolean  "region_only",                                                                 :null => false
    t.boolean  "as_only",                                                                     :null => false
    t.boolean  "prefix_only",                                                                 :null => false
    t.string   "other_countries", :limit => 512,                                              :null => false
    t.integer  "file_maxsize",                                                 :default => 0, :null => false
  end

  add_index "server", ["enabled", "status_baseurl", "score"], :name => "server_enabled_status_baseurl_score_key"
  add_index "server", ["identifier"], :name => "server_identifier_key", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password", :limit => 128
    t.string   "salt",               :limit => 128
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
