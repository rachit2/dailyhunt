# == Schema Information
#
# Table name: courses
#
#  id                                 :bigint           not null, primary key
#  available_free_trail               :boolean
#  description                        :text
#  heading                            :string
#  is_popular                         :boolean          default(FALSE)
#  is_premium                         :boolean          default(FALSE)
#  is_trending                        :boolean          default(FALSE)
#  price                              :integer
#  rank                               :integer
#  thumbnail                          :string
#  video                              :string
#  what_you_will_learn_in_this_course :text
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  category_id                        :bigint
#  content_provider_id                :bigint
#  exam_id                            :bigint
#  language_id                        :bigint
#  sub_category_id                    :bigint
#
# Indexes
#
#  index_courses_on_category_id          (category_id)
#  index_courses_on_content_provider_id  (content_provider_id)
#  index_courses_on_exam_id              (exam_id)
#  index_courses_on_language_id          (language_id)
#  index_courses_on_sub_category_id      (sub_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_id => exams.id)
#
module BxBlockContentmanagement
  class Course < ApplicationRecord
    self.table_name = :courses
    mount_uploader :thumbnail, ImageUploader
    mount_uploader :video, VideoUploader

    belongs_to :category, class_name: 'BxBlockCategories::Category', foreign_key: 'category_id'
    belongs_to :sub_category, class_name: 'BxBlockCategories::SubCategory', foreign_key: 'sub_category_id'
    belongs_to :language, class_name: 'BxBlockLanguageoptions::Language'
    has_many :course_instructors, class_name: 'BxBlockContentmanagement::CourseInstructor', dependent: :destroy
    has_many :instructors, class_name: 'BxBlockContentmanagement::Instructor', through: :course_instructors
    belongs_to :content_provider, class_name: 'BxBlockAdmin::AdminUser', foreign_key: :content_provider_id
    validates_presence_of :thumbnail, :video, :heading, :description, :language, :price
    has_many :ratings, as: :reviewable, class_name: 'BxBlockContentmanagement::Rating', dependent: :destroy
    has_many :lessions, class_name: 'BxBlockContentmanagement::Lession', inverse_of: :course, dependent: :destroy
    has_many :courses_lession_contents, class_name: 'BxBlockContentmanagement::CoursesLessionContent', dependent: :destroy
    has_many :lession_contents, class_name: 'BxBlockContentmanagement::LessionContent', through: :lessions
    has_many :order_courses, class_name: 'BxBlockContentmanagement::OrderCourse', dependent: :destroy
    has_many :course_orders, class_name: 'BxBlockContentmanagement::CourseOrder', through: :order_courses
    has_many :accounts, class_name: 'AccountBlock::Account', through: :course_orders
    has_many :freetrails, dependent: :destroy
    has_many :bookmarks, class_name: "BxBlockContentmanagement::Bookmark", as: :bookmarkable, dependent: :destroy
    has_many :account_bookmarks, class_name: "AccountBlock::Account", through: :bookmarks, source: :account
    validate :check_partner
    has_many :banners, as: :bannerable, dependent: :destroy
    belongs_to :exam, class_name:"BxBlockContentmanagement::Exam", optional: true
    accepts_nested_attributes_for :lessions, allow_destroy: true
    has_and_belongs_to_many :colleges, class_name: "BxBlockProfile::College"

    def check_partner
      errors.add(:content_provider, "only partner's are alowed.") if !self.content_provider&.partner?
    end

    def name
      heading
    end

    rails_admin do
      edit do
        field :heading
        field :description
        field :available_free_trail
        field :category_id do
          label 'Category'
          help 'Required'
          partial "single_category_select"
        end
        field :sub_category_id do
          label 'Sub category'
          help 'Required'
          partial "single_sub_category_select"
        end
        field :exam
        field :colleges
        field :what_you_will_learn_in_this_course
        field :language
        field :content_provider do
          associated_collection_scope do
            proc { |scope| scope.joins(:partner).where.not(partners: {id: nil}) }
          end
        end
        field :price
        field :instructors
        field :rank
        field :is_popular
        field :is_trending
        field :is_premium
        field :thumbnail, :carrierwave
        field :video, :carrierwave
        field :lessions
      end
    end

  end
end
