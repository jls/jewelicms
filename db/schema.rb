# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101023172331) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.integer  "channel_id"
    t.boolean  "is_published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "author_id"
    t.boolean  "comments_enabled", :default => true
  end

  add_index "articles", ["slug"], :name => "index_articles_on_slug", :unique => true

  create_table "articles_categories", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "category_id"
  end

  create_table "categories", :force => true do |t|
    t.integer  "channel_id"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["slug"], :name => "index_categories_on_slug"

  create_table "channels", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_public",              :default => true
    t.integer  "renders_as_channel_id"
    t.boolean  "publishes_to_home_page"
  end

  add_index "channels", ["slug"], :name => "index_channels_on_slug", :unique => true

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "body"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_published", :default => false
    t.string   "author_url"
    t.string   "user_ip"
    t.string   "user_agent"
    t.string   "referrer"
    t.boolean  "is_spam"
    t.string   "permalink"
  end

  create_table "data_field_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_fields", :force => true do |t|
    t.string   "label"
    t.integer  "channel_id"
    t.integer  "data_field_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_filter_id"
  end

  create_table "data_values", :force => true do |t|
    t.integer  "article_id"
    t.integer  "data_field_id"
    t.text     "data_value",    :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "filter_id"
  end

  create_table "filters", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "site_name"
    t.boolean  "show_help",  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
