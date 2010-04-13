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

ActiveRecord::Schema.define(:version => 20100413150454) do

  create_table "currencies", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "symbol",     :null => false
    t.string   "iso_code",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "currencies", ["iso_code"], :name => "index_currencies_on_iso_code", :unique => true
  add_index "currencies", ["name"], :name => "index_currencies_on_name", :unique => true
  add_index "currencies", ["symbol"], :name => "index_currencies_on_symbol", :unique => true

  create_table "people", :force => true do |t|
    t.string   "first_names",   :null => false
    t.string   "surname",       :null => false
    t.string   "email_address", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end