# == Schema Information
#
# Table name: accounts
#
#  id                :bigint           not null, primary key
#  activated         :boolean          default(FALSE), not null
#  city              :string
#  country_code      :integer
#  dob               :date
#  email             :string
#  email_verified    :boolean
#  first_name        :string
#  full_phone_number :string
#  gender            :integer
#  last_name         :string
#  last_visit_at     :datetime
#  password_digest   :string
#  phone_number      :bigint
#  phone_verified    :boolean
#  type              :string
#  user_name         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  app_language_id   :integer
#  desktop_device_id :string
#  device_id         :string
#  role_id           :integer
#  unique_auth_id    :text
#
module AccountBlock
  class Account < AccountBlock::ApplicationRecord
    self.table_name = :accounts

    include Wisper::Publisher

    belongs_to :app_language, -> { app_languages },class_name: "BxBlockLanguageoptions::Language", foreign_key: :app_language_id, optional: true

    has_one :image, as: :attached_item, dependent: :destroy
    has_one :profile, class_name: 'BxBlockProfile::Profile', dependent: :destroy
    has_one :course_cart, class_name: 'BxBlockContentmanagement::CourseCart', dependent: :destroy
    has_many :account_jobs, class_name:"BxBlockJobs::AccountJob", dependent: :destroy
    has_many :account_experts, class_name:"BxBlockExperts::AccountExpert", dependent: :destroy
    has_many :career_experts, class_name:"BxBlockExperts::CareerExpert", through: :account_experts
    before_save :email_or_phone_present
    before_save :change_in_email, if: :will_save_change_to_email?
    before_save :change_in_phone, if: :will_save_change_to_full_phone_number?


    enum gender: ["male", "female", "other"]

    # http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html#method-i-accepts_nested_attributes_for
    accepts_nested_attributes_for :image, allow_destroy: true
    accepts_nested_attributes_for :profile, allow_destroy: true, update_only: true

    has_many :contents_languages, class_name: "BxBlockLanguageoptions::ContentLanguage", join_table: "contents_languages", dependent: :destroy
    has_many :languages, -> { content_languages }, class_name: "BxBlockLanguageoptions::Language", through: :contents_languages, join_table: "contents_languages"
    has_many :user_sub_categories, class_name: "BxBlockCategories::UserSubCategory", join_table: "user_sub_categoeries", dependent: :destroy
    has_many :sub_categories, class_name: "BxBlockCategories::SubCategory", through: :user_sub_categories, join_table: "user_sub_categoeries", foreign_key: :foreign_key
    has_many :user_categories, class_name: "BxBlockCategories::UserCategory", join_table: "user_categoeries", dependent: :destroy
    has_many :categories, class_name: "BxBlockCategories::Category", through: :user_categories, join_table: "user_categoeries", foreign_key: :foreign_key
    has_many :bookmarks, class_name: "BxBlockContentmanagement::Bookmark", dependent: :destroy
    has_many :content_followings, class_name: "BxBlockContentmanagement::Content", through: :bookmarks, source: :bookmarkable, source_type: 'BxBlockContentmanagement::Content'
    has_many :course_followings, class_name: "BxBlockContentmanagement::Course", through: :bookmarks, source: :bookmarkable, source_type: 'BxBlockContentmanagement::Course'
    has_many :job_followings, class_name: "BxBlockJobs::Job", through: :bookmarks, source: :bookmarkable, source_type: 'BxBlockJobs::Job'
    has_many :expert_followings, class_name: "BxBlockExperts::CareerExpert", through: :bookmarks, source: :bookmarkable, source_type: 'BxBlockExperts::CareerExpert'
    has_many :company_followings, class_name: "BxBlockCompany::Company", through: :bookmarks, source: :bookmarkable, source_type: 'BxBlockCompany::Company'
    has_many :followers, class_name: "BxBlockContentmanagement::Follow", dependent: :destroy
    has_many :content_provider_followings, class_name: "BxBlockAdmin::AdminUser", through: :followers, source: :content_provider
    has_many :questions, class_name: "BxBlockCommunityforum::Question", dependent: :destroy
    has_many :answers, class_name: "BxBlockCommunityforum::Answer", dependent: :destroy
    has_many :comments, class_name: "BxBlockCommunityforum::Comment", dependent: :destroy
    has_many :votes, class_name: "BxBlockCommunityforum::Vote", dependent: :destroy
    has_many :likes, class_name: "BxBlockCommunityforum::Like", dependent: :destroy
    has_many :ratings, class_name: "BxBlockContentmanagement::Rating", dependent: :destroy
    has_many :order_courses, class_name: "BxBlockContentmanagement::OrderCourse", dependent: :destroy
    has_many :course_orders, class_name: 'BxBlockContentmanagement::CourseOrder', dependent: :destroy
    has_many :courses, class_name: 'BxBlockContentmanagement::Course', through: :course_orders, dependent: :destroy
    has_many :payments, class_name: "BxBlockPayments::Payment", dependent: :destroy
    has_many :freetrails, class_name: "BxBlockContentmanagement::Freetrail", dependent: :destroy
    has_many :freetrails_courses, class_name: "BxBlockContentmanagement::Course", through: :freetrails, source: :course
    has_many :user_quizzes, class_name: 'BxBlockContentmanagement::UserQuiz', dependent: :destroy
    has_many :user_assessments, class_name: 'BxBlockContentmanagement::UserAssessment', dependent: :destroy
    has_many :courses_lession_contents, class_name: 'BxBlockContentmanagement::CoursesLessionContent', dependent: :destroy

    validates_uniqueness_of :email, case_sensitive: false, allow_blank: true,:message => 'This Email ID Is Already Registered with Us. Please Login or Select Forgot Password'
    validates_uniqueness_of :full_phone_number, allow_blank: true, :message => 'This Phone Number Is Already Registered with Us. Please Login or Select Forgot Password'

    has_and_belongs_to_many :jobs, class_name: "BxBlockJobs::Job"

    # callbacks
    before_validation :parse_full_phone_number


    def name
      first_name.presence || email.presence || phone_number.presence
    end

    def validate_email_phone
      email = AccountBlock::EmailOtp.current_user.find_by(email: current_user.email)
      phone = AccountBlock::SmsOtp.find_by(full_phone_number: current_user.full_phone_number)
    end

    rails_admin do
      configure :type do
        label 'Account Type'
      end

      list do
        field :first_name
        field :last_name
        field :phone_number
        field :email
        field :activated do
          filterable false
        end
        field :type do
          filterable false
        end
        field :created_at do
          filterable false
        end
        field :updated_at do
          filterable false
        end
      end

      show do
        field :first_name
        field :last_name
        field :phone_number
        field :email
        field :activated
        field :image do
          pretty_value do
            if bindings[:object].image.present?
              bindings[:view].tag(:img, { :src => bindings[:object].image.image.url, :class => 'admin_icon' })
            end
          end
        end
        field :type
        field :profile
        field :created_at
        field :updated_at
      end
    end

    private
    def parse_full_phone_number
      phone = Phonelib.parse(full_phone_number)
      self.full_phone_number = phone.sanitized
      self.country_code      = phone.country_code
      self.phone_number      = phone.raw_national
    end

    def valid_phone_number
      unless Phonelib.valid?(full_phone_number)
        errors.add(:full_phone_number, "Invalid or Unrecognized Phone Number")
      end
    end

    def email_or_phone_present
      unless email.present? or full_phone_number.present?
        errors.add(:account, "Either Add Phone Number or Email")
      end
    end

    def change_in_email
      self.email_verified = false
    end

    def change_in_phone
      self.phone_verified = false
    end
  end
end
