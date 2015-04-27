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

ActiveRecord::Schema.define(:version => 20150426045036) do

  create_table "answers", :force => true do |t|
    t.string   "ans"
    t.integer  "leads_to"
    t.integer  "results_to"
    t.integer  "questionnaire_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "application_types", :force => true do |t|
    t.string   "app_type"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.text     "description", :default => "", :null => false
  end

  create_table "application_types_forms", :id => false, :force => true do |t|
    t.integer "application_type_id"
    t.integer "form_id"
  end

  create_table "applications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "application_type_id"
    t.integer  "year"
    t.text     "content",             :default => "",    :null => false
    t.boolean  "completed",           :default => false, :null => false
    t.boolean  "approved",            :default => false, :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.decimal  "amount_paid",         :default => 0.0
    t.string   "payment_id"
    t.boolean  "has_paid",            :default => false, :null => false
  end

  create_table "form_questions", :force => true do |t|
    t.text     "question"
    t.text     "answers"
    t.string   "form_type"
    t.string   "question_type"
    t.integer  "order"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "form_id"
  end

  add_index "form_questions", ["form_id"], :name => "index_form_questions_on_form_id"

  create_table "forms", :force => true do |t|
    t.string   "form_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questionnaires", :force => true do |t|
    t.text     "question"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false, :null => false
    t.string   "contact_person",         :default => "",    :null => false
    t.string   "company_name",           :default => "",    :null => false
    t.string   "telephone",              :default => "",    :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
