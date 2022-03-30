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

ActiveRecord::Schema.define(version: 203006110549291) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_experts", force: :cascade do |t|
    t.integer "account_id"
    t.integer "career_expert_id"
    t.integer "mode"
    t.boolean "follow"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "account_jobs", force: :cascade do |t|
    t.string "job_id"
    t.string "company_id"
    t.string "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "full_phone_number"
    t.integer "country_code"
    t.bigint "phone_number"
    t.string "email"
    t.boolean "activated", default: false, null: false
    t.string "device_id"
    t.text "unique_auth_id"
    t.string "password_digest"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.integer "role_id"
    t.string "city"
    t.integer "app_language_id"
    t.datetime "last_visit_at"
    t.string "desktop_device_id"
    t.date "dob"
    t.integer "gender"
    t.boolean "email_verified"
    t.boolean "phone_verified"
  end

  create_table "accounts_jobs", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "job_id"
    t.index ["account_id"], name: "index_accounts_jobs_on_account_id"
    t.index ["job_id"], name: "index_accounts_jobs_on_job_id"
  end

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_user_roles", force: :cascade do |t|
    t.bigint "admin_user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_user_id"], name: "index_admin_user_roles_on_admin_user_id"
    t.index ["role_id"], name: "index_admin_user_roles_on_role_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "account_id"
    t.bigint "question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_answers_on_account_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "application_configs", force: :cascade do |t|
    t.string "mime_type"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "home_page_description"
  end

  create_table "application_message_translations", force: :cascade do |t|
    t.bigint "application_message_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "message", null: false
    t.index ["application_message_id"], name: "index_4df4694a81c904bef7786f2b09342fde44adca5f"
    t.index ["locale"], name: "index_application_message_translations_on_locale"
  end

  create_table "application_messages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.string "image"
    t.integer "career_expert_id"
    t.integer "category_id"
    t.integer "view", default: 0
    t.integer "status"
    t.datetime "publish_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "assessments", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.bigint "language_id", null: false
    t.integer "content_provider_id"
    t.boolean "is_popular"
    t.boolean "is_trending"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "timer"
    t.bigint "category_id"
    t.bigint "sub_category_id"
    t.bigint "exam_id"
    t.index ["category_id"], name: "index_assessments_on_category_id"
    t.index ["exam_id"], name: "index_assessments_on_exam_id"
    t.index ["language_id"], name: "index_assessments_on_language_id"
    t.index ["sub_category_id"], name: "index_assessments_on_sub_category_id"
  end

  create_table "audio_podcasts", force: :cascade do |t|
    t.string "heading"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "audios", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "audio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_audios_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_audios_on_attached_item_type"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "banners", force: :cascade do |t|
    t.integer "status"
    t.boolean "is_explore"
    t.integer "rank"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "bannerable_type"
    t.integer "bannerable_id"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_article"
    t.boolean "is_video"
  end

  create_table "boards", force: :cascade do |t|
    t.string "name"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "bookmarkable_id"
    t.string "bookmarkable_type"
    t.index ["account_id"], name: "index_bookmarks_on_account_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_university_and_degrees", force: :cascade do |t|
    t.bigint "university_id", null: false
    t.bigint "degree_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["degree_id"], name: "index_bx_block_profile_university_and_degrees_on_degree_id"
    t.index ["university_id"], name: "index_bx_block_profile_university_and_degrees_on_university_id"
  end

  create_table "career_experts", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "designation"
    t.string "status"
    t.decimal "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image"
    t.integer "rating"
    t.string "heading"
  end

  create_table "career_experts_exams", id: false, force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "career_expert_id", null: false
  end

  create_table "cart_courses", force: :cascade do |t|
    t.bigint "course_cart_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_cart_id"], name: "index_cart_courses_on_course_cart_id"
    t.index ["course_id"], name: "index_cart_courses_on_course_id"
  end

  create_table "catalogue_variant_colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variant_sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variants", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "catalogue_variant_color_id"
    t.bigint "catalogue_variant_size_id"
    t.decimal "price"
    t.integer "stock_qty"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount_price"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.index ["catalogue_id"], name: "index_catalogue_variants_on_catalogue_id"
    t.index ["catalogue_variant_color_id"], name: "index_catalogue_variants_on_catalogue_variant_color_id"
    t.index ["catalogue_variant_size_id"], name: "index_catalogue_variants_on_catalogue_variant_size_id"
  end

  create_table "catalogues", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.bigint "brand_id"
    t.string "name"
    t.string "sku"
    t.string "description"
    t.datetime "manufacture_date"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.integer "availability"
    t.integer "stock_qty"
    t.decimal "weight"
    t.float "price"
    t.boolean "recommended"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.index ["brand_id"], name: "index_catalogues_on_brand_id"
    t.index ["category_id"], name: "index_catalogues_on_category_id"
    t.index ["sub_category_id"], name: "index_catalogues_on_sub_category_id"
  end

  create_table "catalogues_tags", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "tag_id", null: false
    t.index ["catalogue_id"], name: "index_catalogues_tags_on_catalogue_id"
    t.index ["tag_id"], name: "index_catalogues_tags_on_tag_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_user_id"
    t.integer "rank"
    t.string "light_icon"
    t.string "light_icon_active"
    t.string "light_icon_inactive"
    t.string "dark_icon"
    t.string "dark_icon_active"
    t.string "dark_icon_inactive"
    t.integer "identifier"
  end

  create_table "categories_partners", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "partner_id", null: false
    t.index ["category_id"], name: "index_categories_partners_on_category_id"
    t.index ["partner_id"], name: "index_categories_partners_on_partner_id"
  end

  create_table "categories_sub_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.index ["category_id"], name: "index_categories_sub_categories_on_category_id"
    t.index ["sub_category_id"], name: "index_categories_sub_categories_on_sub_category_id"
  end

  create_table "certification_profiles", force: :cascade do |t|
    t.bigint "certification_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["certification_id"], name: "index_certification_profiles_on_certification_id"
    t.index ["profile_id"], name: "index_certification_profiles_on_profile_id"
  end

  create_table "certifications", force: :cascade do |t|
    t.string "certification_course_name"
    t.string "provided_by"
    t.integer "duration"
    t.integer "completion_year"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "location_id", null: false
    t.string "address"
    t.string "logo"
    t.index ["location_id"], name: "index_cities_on_location_id"
  end

  create_table "college_and_degrees", force: :cascade do |t|
    t.bigint "college_id", null: false
    t.bigint "degree_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["college_id"], name: "index_college_and_degrees_on_college_id"
    t.index ["degree_id"], name: "index_college_and_degrees_on_degree_id"
  end

  create_table "colleges", force: :cascade do |t|
    t.string "name"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_others", default: false
    t.boolean "is_popular", default: false
    t.boolean "is_featured", default: false
    t.float "total_fees_min"
    t.float "total_fees_max"
    t.float "median_salary"
    t.float "course_rating"
    t.string "website_url"
    t.bigint "university_id", null: false
    t.bigint "location_id", null: false
    t.string "logo"
    t.bigint "city_id"
    t.integer "sub_category_id"
    t.integer "admission_process"
    t.integer "college_type"
    t.index ["city_id"], name: "index_colleges_on_city_id"
    t.index ["location_id"], name: "index_colleges_on_location_id"
    t.index ["university_id"], name: "index_colleges_on_university_id"
  end

  create_table "colleges_courses", id: false, force: :cascade do |t|
    t.bigint "college_id", null: false
    t.bigint "course_id", null: false
  end

  create_table "colleges_specializations", id: false, force: :cascade do |t|
    t.bigint "college_id", null: false
    t.bigint "specialization_id", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "description"
    t.bigint "commentable_id"
    t.string "commentable_type"
    t.bigint "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_comments_on_account_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "about"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "popular"
    t.boolean "trending"
    t.string "logo"
  end

  create_table "company_addresses", force: :cascade do |t|
    t.string "address"
    t.integer "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_job_positions", force: :cascade do |t|
    t.integer "company_id"
    t.integer "job_id"
    t.boolean "is_vacant"
    t.string "employment_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "salary"
  end

  create_table "content_tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_content_tags_on_name", unique: true
  end

  create_table "content_texts", force: :cascade do |t|
    t.string "headline"
    t.string "content"
    t.string "hyperlink"
    t.string "affiliation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "career_expert_id"
    t.bigint "view_count", default: 0
    t.index ["career_expert_id"], name: "index_content_texts_on_career_expert_id"
  end

  create_table "content_types", force: :cascade do |t|
    t.string "name"
    t.integer "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "identifier"
    t.integer "rank"
  end

  create_table "content_types_partners", force: :cascade do |t|
    t.bigint "content_type_id", null: false
    t.bigint "partner_id", null: false
    t.index ["content_type_id"], name: "index_content_types_partners_on_content_type_id"
    t.index ["partner_id"], name: "index_content_types_partners_on_partner_id"
  end

  create_table "content_videos", force: :cascade do |t|
    t.string "separate_section"
    t.string "headline"
    t.string "description"
    t.string "thumbnails"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "exam_id"
    t.bigint "career_expert_id"
    t.bigint "view_count", default: 0
    t.index ["career_expert_id"], name: "index_content_videos_on_career_expert_id"
    t.index ["exam_id"], name: "index_content_videos_on_exam_id"
  end

  create_table "contents", force: :cascade do |t|
    t.integer "sub_category_id"
    t.integer "category_id"
    t.integer "content_type_id"
    t.integer "language_id"
    t.string "contentable_type"
    t.bigint "contentable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
    t.datetime "publish_date"
    t.bigint "author_id"
    t.string "searchable_text"
    t.bigint "view_count", default: 0
    t.boolean "archived", default: false
    t.integer "review_status"
    t.string "feedback"
    t.integer "admin_user_id"
    t.boolean "feature_article"
    t.boolean "feature_video"
    t.integer "crm_type"
    t.integer "crm_id"
    t.string "detail_url"
    t.boolean "is_popular"
    t.boolean "is_trending"
    t.boolean "is_featured"
    t.integer "career_expert_id"
    t.index ["author_id"], name: "index_contents_on_author_id"
    t.index ["contentable_type", "contentable_id"], name: "index_contents_on_contentable_type_and_contentable_id"
  end

  create_table "contents_languages", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_contents_languages_on_account_id"
    t.index ["language_id"], name: "index_contents_languages_on_language_id"
  end

  create_table "course_carts", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_course_carts_on_account_id"
  end

  create_table "course_instructors", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "instructor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_course_instructors_on_course_id"
    t.index ["instructor_id"], name: "index_course_instructors_on_instructor_id"
  end

  create_table "course_orders", force: :cascade do |t|
    t.integer "status"
    t.bigint "account_id", null: false
    t.integer "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_course_orders_on_account_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.bigint "language_id"
    t.bigint "content_provider_id"
    t.integer "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_popular", default: false
    t.boolean "is_trending", default: false
    t.boolean "is_premium", default: false
    t.string "thumbnail"
    t.string "video"
    t.integer "rank"
    t.bigint "category_id"
    t.bigint "sub_category_id"
    t.text "what_you_will_learn_in_this_course"
    t.boolean "available_free_trail"
    t.bigint "exam_id"
    t.index ["category_id"], name: "index_courses_on_category_id"
    t.index ["content_provider_id"], name: "index_courses_on_content_provider_id"
    t.index ["exam_id"], name: "index_courses_on_exam_id"
    t.index ["language_id"], name: "index_courses_on_language_id"
    t.index ["sub_category_id"], name: "index_courses_on_sub_category_id"
  end

  create_table "courses_lession_contents", force: :cascade do |t|
    t.integer "course_id"
    t.integer "lessions_content_id"
    t.integer "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cta", force: :cascade do |t|
    t.string "headline"
    t.text "description"
    t.bigint "category_id"
    t.string "long_background_image"
    t.string "square_background_image"
    t.string "button_text"
    t.string "redirect_url"
    t.integer "text_alignment"
    t.integer "button_alignment"
    t.boolean "is_square_cta"
    t.boolean "is_long_rectangle_cta"
    t.boolean "is_text_cta"
    t.boolean "is_image_cta"
    t.boolean "has_button"
    t.boolean "visible_on_home_page"
    t.boolean "visible_on_details_page"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "location_id"
    t.bigint "city_id"
    t.index ["category_id"], name: "index_cta_on_category_id"
    t.index ["city_id"], name: "index_cta_on_city_id"
    t.index ["location_id"], name: "index_cta_on_location_id"
  end

  create_table "dashboards", force: :cascade do |t|
    t.string "title"
    t.integer "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "degrees", force: :cascade do |t|
    t.string "name"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "domain_work_functions", force: :cascade do |t|
    t.string "name"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "education_level_profiles", force: :cascade do |t|
    t.bigint "education_level_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "board_id"
    t.bigint "standard_id"
    t.string "school_name"
    t.bigint "degree_id"
    t.integer "educational_course_id"
    t.bigint "college_id"
    t.string "passing_year"
    t.string "college_name"
    t.bigint "specialization_id"
    t.index ["board_id"], name: "index_education_level_profiles_on_board_id"
    t.index ["college_id"], name: "index_education_level_profiles_on_college_id"
    t.index ["degree_id"], name: "index_education_level_profiles_on_degree_id"
    t.index ["education_level_id"], name: "index_education_level_profiles_on_education_level_id"
    t.index ["profile_id"], name: "index_education_level_profiles_on_profile_id"
    t.index ["standard_id"], name: "index_education_level_profiles_on_standard_id"
  end

  create_table "education_levels", force: :cascade do |t|
    t.string "name"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "level"
  end

  create_table "educational_courses", force: :cascade do |t|
    t.string "name"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "email_otps", force: :cascade do |t|
    t.string "email"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "employment_detail_profiles", force: :cascade do |t|
    t.bigint "employment_detail_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employment_detail_id"], name: "index_employment_detail_profiles_on_employment_detail_id"
    t.index ["profile_id"], name: "index_employment_detail_profiles_on_profile_id"
  end

  create_table "employment_details", force: :cascade do |t|
    t.string "last_employer"
    t.string "designation"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "domain_work_function_id"
  end

  create_table "epubs", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exam_sections", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.bigint "exam_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exam_id"], name: "index_exam_sections_on_exam_id"
  end

  create_table "exam_subject_profiles", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profile_id"], name: "index_exam_subject_profiles_on_profile_id"
    t.index ["subject_id"], name: "index_exam_subject_profiles_on_subject_id"
  end

  create_table "exam_updates", force: :cascade do |t|
    t.date "date"
    t.text "update_message"
    t.string "link"
    t.bigint "exam_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exam_id"], name: "index_exam_updates_on_exam_id"
  end

  create_table "exams", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.datetime "end_date"
    t.datetime "start_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "category_id"
    t.bigint "sub_category_id"
    t.string "thumbnail"
    t.integer "content_provider_id"
    t.boolean "popular"
    t.index ["category_id"], name: "index_exams_on_category_id"
    t.index ["sub_category_id"], name: "index_exams_on_sub_category_id"
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question"
    t.text "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "content_provider_id"
    t.bigint "content_video_id"
    t.bigint "content_text_id"
    t.index ["account_id"], name: "index_follows_on_account_id"
    t.index ["content_text_id"], name: "index_follows_on_content_text_id"
    t.index ["content_video_id"], name: "index_follows_on_content_video_id"
  end

  create_table "freetrails", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_freetrails_on_account_id"
    t.index ["course_id"], name: "index_freetrails_on_course_id"
  end

  create_table "govt_jobs", force: :cascade do |t|
    t.bigint "education_level_id"
    t.bigint "specialization_id"
    t.bigint "profile_id"
    t.integer "caste_category"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["education_level_id"], name: "index_govt_jobs_on_education_level_id"
    t.index ["profile_id"], name: "index_govt_jobs_on_profile_id"
    t.index ["specialization_id"], name: "index_govt_jobs_on_specialization_id"
  end

  create_table "help_and_supports", force: :cascade do |t|
    t.string "question"
    t.text "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_images_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_images_on_attached_item_type"
  end

  create_table "instructors", force: :cascade do |t|
    t.string "name"
    t.string "bio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "designation"
  end

  create_table "job_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "logo"
  end

  create_table "job_locations", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "job_places", force: :cascade do |t|
    t.integer "job_location_id"
    t.integer "job_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "job_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "requirement"
    t.integer "job_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "job_type_id"
    t.integer "job_category_id"
    t.integer "experience"
    t.integer "sub_category_id"
    t.string "heading"
    t.boolean "popular"
    t.boolean "trending"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.string "language_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_content_language"
    t.boolean "is_app_language"
  end

  create_table "lession_contents", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.integer "rank"
    t.integer "content_type"
    t.integer "duration"
    t.bigint "lession_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "video"
    t.string "file_content"
    t.boolean "is_free", default: false
    t.string "thumbnail"
    t.index ["lession_id"], name: "index_lession_contents_on_lession_id"
  end

  create_table "lessions", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.integer "rank"
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_lessions_on_course_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "likeable_id"
    t.string "likeable_type"
    t.boolean "is_like"
    t.bigint "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_likes_on_account_id"
  end

  create_table "live_streams", force: :cascade do |t|
    t.string "headline"
    t.string "description"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "location_cities", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_location_cities_on_city_id"
    t.index ["location_id"], name: "index_location_cities_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.boolean "is_top_location", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
    t.string "logo"
  end

  create_table "login_background_files", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "login_background_file"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_login_background_files_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_login_background_files_on_attached_item_type"
  end

  create_table "mock_tests", force: :cascade do |t|
    t.string "description"
    t.integer "exam_id"
    t.string "heading"
    t.string "pdf"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "options", force: :cascade do |t|
    t.string "answer"
    t.text "description"
    t.boolean "is_right"
    t.bigint "test_question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["test_question_id"], name: "index_options_on_test_question_id"
  end

  create_table "order_courses", force: :cascade do |t|
    t.bigint "course_order_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.index ["course_id"], name: "index_order_courses_on_course_id"
    t.index ["course_order_id"], name: "index_order_courses_on_course_order_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.string "spoc_name"
    t.string "spoc_contact"
    t.text "address"
    t.integer "partner_type"
    t.integer "partnership_type"
    t.float "partner_margins_per"
    t.boolean "includes_gst"
    t.float "tax_margins"
    t.integer "status"
    t.boolean "created_by_admin", default: true
    t.bigint "admin_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "bank_ifsc"
    t.bigint "account_number"
    t.string "account_name"
    t.string "bank_name"
    t.index ["admin_user_id"], name: "index_partners_on_admin_user_id"
  end

  create_table "partners_sub_categories", force: :cascade do |t|
    t.bigint "partner_id", null: false
    t.bigint "sub_category_id", null: false
    t.index ["partner_id"], name: "index_partners_sub_categories_on_partner_id"
    t.index ["sub_category_id"], name: "index_partners_sub_categories_on_sub_category_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "course_order_id", null: false
    t.bigint "account_id", null: false
    t.integer "price"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_payments_on_account_id"
    t.index ["course_order_id"], name: "index_payments_on_course_order_id"
  end

  create_table "pdfs", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "pdf"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_pdfs_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_pdfs_on_attached_item_type"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "board_id"
    t.string "school_name"
    t.bigint "standard_id"
    t.bigint "degree_id"
    t.bigint "specialization_id"
    t.bigint "educational_course_id"
    t.bigint "college_id"
    t.integer "passing_year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "higher_education_level_id"
    t.string "completed_profile_categories", default: [], array: true
    t.bigint "competitive_exam_standard_id"
    t.bigint "competitive_exam_board_id"
    t.string "competitive_exam_school_name"
    t.bigint "competitive_exam_degree_id"
    t.bigint "competitive_exam_specialization_id"
    t.bigint "competitive_exam_course_id"
    t.bigint "competitive_exam_college_id"
    t.string "competitive_exam_passing_year"
    t.string "college_name"
    t.string "competitive_exam_college_name"
    t.string "cv"
    t.index ["account_id"], name: "index_profiles_on_account_id"
    t.index ["board_id"], name: "index_profiles_on_board_id"
    t.index ["college_id"], name: "index_profiles_on_college_id"
    t.index ["degree_id"], name: "index_profiles_on_degree_id"
    t.index ["educational_course_id"], name: "index_profiles_on_educational_course_id"
    t.index ["specialization_id"], name: "index_profiles_on_specialization_id"
    t.index ["standard_id"], name: "index_profiles_on_standard_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "account_id"
    t.bigint "sub_category_id"
    t.integer "view", default: 0
    t.integer "status"
    t.boolean "closed"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_popular"
    t.boolean "is_trending"
    t.index ["account_id"], name: "index_questions_on_account_id"
    t.index ["sub_category_id"], name: "index_questions_on_sub_category_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.bigint "language_id", null: false
    t.integer "content_provider_id"
    t.boolean "is_popular"
    t.boolean "is_trending"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "timer"
    t.bigint "category_id"
    t.bigint "sub_category_id"
    t.text "quiz_description"
    t.index ["category_id"], name: "index_quizzes_on_category_id"
    t.index ["language_id"], name: "index_quizzes_on_language_id"
    t.index ["sub_category_id"], name: "index_quizzes_on_sub_category_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "rating"
    t.string "review"
    t.bigint "account_id"
    t.string "reviewable_type"
    t.bigint "reviewable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_ratings_on_account_id"
    t.index ["reviewable_type", "reviewable_id"], name: "index_ratings_on_reviewable_type_and_reviewable_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.string "comment"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["catalogue_id"], name: "index_reviews_on_catalogue_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "school_standards", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "standard_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["school_id"], name: "index_school_standards_on_school_id"
    t.index ["standard_id"], name: "index_school_standards_on_standard_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.boolean "is_featured"
    t.boolean "is_popular"
    t.float "total_fees_min"
    t.float "total_fees_max"
    t.float "median_salary"
    t.float "course_rating"
    t.integer "rank"
    t.string "website_url"
    t.string "logo"
    t.bigint "location_id", null: false
    t.bigint "board_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "school_type"
    t.integer "language_of_interaction"
    t.integer "admission_process"
    t.bigint "city_id"
    t.index ["board_id"], name: "index_schools_on_board_id"
    t.index ["city_id"], name: "index_schools_on_city_id"
    t.index ["location_id"], name: "index_schools_on_location_id"
  end

  create_table "sms_otps", force: :cascade do |t|
    t.string "full_phone_number"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "specialization_education_levels", force: :cascade do |t|
    t.bigint "education_level_id"
    t.bigint "specialization_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["education_level_id"], name: "index_specialization_education_levels_on_education_level_id"
    t.index ["specialization_id"], name: "index_specialization_education_levels_on_specialization_id"
  end

  create_table "specializations", force: :cascade do |t|
    t.string "name"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "degree_id"
    t.bigint "higher_education_level_id"
    t.integer "college_id"
    t.string "logo"
  end

  create_table "standards", force: :cascade do |t|
    t.string "name"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.integer "rank"
  end

  create_table "subject_education_levels", force: :cascade do |t|
    t.bigint "education_level_profile_id"
    t.bigint "subject_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["education_level_profile_id"], name: "index_subject_education_levels_on_education_level_profile_id"
    t.index ["subject_id"], name: "index_subject_education_levels_on_subject_id"
  end

  create_table "subject_profiles", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profile_id"], name: "index_subject_profiles_on_profile_id"
    t.index ["subject_id"], name: "index_subject_profiles_on_subject_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "test_questions", force: :cascade do |t|
    t.string "question"
    t.integer "options_number"
    t.integer "questionable_id"
    t.string "questionable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tests", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "headline"
  end

  create_table "total_fees", force: :cascade do |t|
    t.bigint "min"
    t.bigint "max"
    t.boolean "is_active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.boolean "is_featured"
    t.bigint "location_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "logo"
    t.float "median_salary"
    t.float "total_fees_min"
    t.float "total_fees_max"
    t.float "course_rating"
    t.index ["location_id"], name: "index_universities_on_location_id"
  end

  create_table "user_assessments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "assessment_id", null: false
    t.integer "tracker"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total"
    t.integer "attempt_count"
    t.index ["account_id"], name: "index_user_assessments_on_account_id"
    t.index ["assessment_id"], name: "index_user_assessments_on_assessment_id"
  end

  create_table "user_categories", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_categories_on_account_id"
    t.index ["category_id"], name: "index_user_categories_on_category_id"
  end

  create_table "user_options", force: :cascade do |t|
    t.string "optionable_type"
    t.integer "optionable_id"
    t.bigint "test_question_id", null: false
    t.bigint "option_id", null: false
    t.integer "rank"
    t.boolean "is_true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["option_id"], name: "index_user_options_on_option_id"
    t.index ["test_question_id"], name: "index_user_options_on_test_question_id"
  end

  create_table "user_quizzes", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "quiz_id", null: false
    t.integer "tracker"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total"
    t.integer "attempt_count"
    t.index ["account_id"], name: "index_user_quizzes_on_account_id"
    t.index ["quiz_id"], name: "index_user_quizzes_on_quiz_id"
  end

  create_table "user_sub_categories", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "sub_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_sub_categories_on_account_id"
    t.index ["sub_category_id"], name: "index_user_sub_categories_on_sub_category_id"
  end

  create_table "videos", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "video"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_videos_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_videos_on_attached_item_type"
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_votes_on_account_id"
    t.index ["question_id"], name: "index_votes_on_question_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_user_roles", "admin_users"
  add_foreign_key "admin_user_roles", "roles"
  add_foreign_key "assessments", "exams"
  add_foreign_key "assessments", "languages"
  add_foreign_key "bookmarks", "accounts"
  add_foreign_key "bx_block_profile_university_and_degrees", "degrees"
  add_foreign_key "bx_block_profile_university_and_degrees", "universities"
  add_foreign_key "cart_courses", "course_carts"
  add_foreign_key "cart_courses", "courses"
  add_foreign_key "catalogue_variants", "catalogue_variant_colors"
  add_foreign_key "catalogue_variants", "catalogue_variant_sizes"
  add_foreign_key "catalogue_variants", "catalogues"
  add_foreign_key "catalogues", "brands"
  add_foreign_key "catalogues", "categories"
  add_foreign_key "catalogues", "sub_categories"
  add_foreign_key "catalogues_tags", "catalogues"
  add_foreign_key "catalogues_tags", "tags"
  add_foreign_key "categories_partners", "categories"
  add_foreign_key "categories_partners", "partners"
  add_foreign_key "categories_sub_categories", "categories"
  add_foreign_key "categories_sub_categories", "sub_categories"
  add_foreign_key "certification_profiles", "certifications"
  add_foreign_key "certification_profiles", "profiles"
  add_foreign_key "cities", "locations"
  add_foreign_key "college_and_degrees", "colleges"
  add_foreign_key "college_and_degrees", "degrees"
  add_foreign_key "colleges", "cities"
  add_foreign_key "colleges", "locations"
  add_foreign_key "colleges", "universities"
  add_foreign_key "content_texts", "career_experts"
  add_foreign_key "content_types_partners", "content_types"
  add_foreign_key "content_types_partners", "partners"
  add_foreign_key "content_videos", "career_experts"
  add_foreign_key "content_videos", "exams"
  add_foreign_key "contents", "authors"
  add_foreign_key "contents_languages", "accounts"
  add_foreign_key "contents_languages", "languages"
  add_foreign_key "course_carts", "accounts"
  add_foreign_key "course_instructors", "courses"
  add_foreign_key "course_instructors", "instructors"
  add_foreign_key "course_orders", "accounts"
  add_foreign_key "courses", "exams"
  add_foreign_key "cta", "cities"
  add_foreign_key "cta", "locations"
  add_foreign_key "education_level_profiles", "education_levels"
  add_foreign_key "education_level_profiles", "profiles"
  add_foreign_key "employment_detail_profiles", "employment_details"
  add_foreign_key "employment_detail_profiles", "profiles"
  add_foreign_key "exam_sections", "exams"
  add_foreign_key "exam_subject_profiles", "profiles"
  add_foreign_key "exam_subject_profiles", "subjects"
  add_foreign_key "exam_updates", "exams"
  add_foreign_key "follows", "accounts"
  add_foreign_key "follows", "content_texts"
  add_foreign_key "follows", "content_videos"
  add_foreign_key "govt_jobs", "education_levels"
  add_foreign_key "govt_jobs", "profiles"
  add_foreign_key "govt_jobs", "specializations"
  add_foreign_key "lession_contents", "lessions"
  add_foreign_key "lessions", "courses"
  add_foreign_key "location_cities", "cities"
  add_foreign_key "location_cities", "locations"
  add_foreign_key "options", "test_questions"
  add_foreign_key "order_courses", "course_orders"
  add_foreign_key "order_courses", "courses"
  add_foreign_key "partners", "admin_users"
  add_foreign_key "partners_sub_categories", "partners"
  add_foreign_key "partners_sub_categories", "sub_categories"
  add_foreign_key "payments", "accounts"
  add_foreign_key "payments", "course_orders"
  add_foreign_key "profiles", "boards"
  add_foreign_key "profiles", "colleges"
  add_foreign_key "profiles", "degrees"
  add_foreign_key "profiles", "educational_courses"
  add_foreign_key "profiles", "specializations"
  add_foreign_key "profiles", "standards"
  add_foreign_key "quizzes", "languages"
  add_foreign_key "reviews", "catalogues"
  add_foreign_key "school_standards", "schools"
  add_foreign_key "school_standards", "standards"
  add_foreign_key "schools", "boards"
  add_foreign_key "schools", "cities"
  add_foreign_key "schools", "locations"
  add_foreign_key "subject_profiles", "profiles"
  add_foreign_key "subject_profiles", "subjects"
  add_foreign_key "taggings", "content_tags", column: "tag_id"
  add_foreign_key "universities", "locations"
  add_foreign_key "user_assessments", "accounts"
  add_foreign_key "user_assessments", "assessments"
  add_foreign_key "user_categories", "accounts"
  add_foreign_key "user_categories", "categories"
  add_foreign_key "user_options", "options"
  add_foreign_key "user_options", "test_questions"
  add_foreign_key "user_quizzes", "accounts"
  add_foreign_key "user_quizzes", "quizzes"
  add_foreign_key "user_sub_categories", "accounts"
  add_foreign_key "user_sub_categories", "sub_categories"
end
