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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130104220025) do

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.decimal  "discount",    :precision => 2, :scale => 2
    t.decimal  "value",       :precision => 8, :scale => 2
    t.string   "image_url"
    t.text     "description"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "retailer_id"
    t.boolean  "captcha"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "brand_id"
    t.string   "title"
    t.decimal  "price"
    t.decimal  "value"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
