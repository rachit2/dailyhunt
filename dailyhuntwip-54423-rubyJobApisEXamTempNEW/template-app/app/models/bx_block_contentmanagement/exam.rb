# == Schema Information
#
# Table name: exams
#
#  id                  :bigint           not null, primary key
#  description         :text
#  end_date            :datetime
#  heading             :string
#  popular             :boolean
#  start_date          :datetime
#  thumbnail           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  category_id         :bigint
#  content_provider_id :integer
#  sub_category_id     :bigint
#
# Indexes
#
#  index_exams_on_category_id      (category_id)
#  index_exams_on_sub_category_id  (sub_category_id)
#
module BxBlockContentmanagement
  class Exam < ApplicationRecord
    self.table_name = :exams
    mount_uploader :thumbnail, ImageUploader
    has_many :mock_tests, class_name:"BxBlockContentmanagement::MockTest", dependent: :destroy
    belongs_to :category, class_name: 'BxBlockCategories::Category', foreign_key: 'category_id'
    belongs_to :sub_category, class_name: 'BxBlockCategories::SubCategory', foreign_key: 'sub_category_id'
    belongs_to :content_provider, class_name: 'BxBlockAdmin::AdminUser', foreign_key: :content_provider_id
    # has_many :content_videos, class_name:"BxBlockContentmanagement::Content", dependent: :destroy
    has_many :pdfs, as: :attached_item, dependent: :destroy, inverse_of: :attached_item
    has_many :banners, class_name: "BxBlockContentmanagement::Banner", as: :bannerable, dependent: :destroy
    has_many :courses, class_name:"BxBlockContentmanagement::Course", dependent: :destroy
    has_many :content_videos, class_name:"BxBlockContentmanagement::ContentVideo", dependent: :destroy
    has_many :assessments, class_name:"BxBlockContentmanagement::Assessment", dependent: :destroy
    has_many :exam_updates, dependent: :destroy, inverse_of: :exam
    has_and_belongs_to_many :career_experts, class_name:"BxBlockExperts::CareerExpert", dependent: :destroy
    accepts_nested_attributes_for :exam_updates

    has_many :exam_sections, dependent: :destroy
    accepts_nested_attributes_for :exam_sections
    validates_presence_of :heading, :start_date,:end_date
    scope :popular_exams, -> { where(popular: true) }
    scope :by_dates, ->(to, from) { where(:end_date => to..from).or(self.where(:start_date => to..from)) }
    scope :current_month, -> { by_dates(Date.today.beginning_of_month, Date.today.end_of_month) }
    validate :check_to_and_from
    accepts_nested_attributes_for :pdfs, allow_destroy: true

    acts_as_taggable_on :tags

    def name
      heading
    end

    rails_admin do
      configure :description do
        pretty_value do
          value&.html_safe
        end
      end

      list do
        field :heading
        field :description
        field :start_date
        field :end_date
        field :category
        field :sub_category
        field :content_provider
        field :created_at
        field :updated_at
      end

      edit do
        field :heading
        field :career_experts
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
        field :courses
        field :mock_tests
        field :tags do
          searchable [{ ActsAsTaggableOn::Tag => :name}]
          label "Tags"
          pretty_value do
            bindings[:object].tag_list
          end
        end
        field :content_provider do
          associated_collection_scope do
            proc { |scope| scope.joins(:partner).where.not(partners: {id: nil}) }
          end
        end
        field :popular
        field :thumbnail
        field :pdfs do
          label 'Sample Paper'
        end
        field :description do
          partial 'exam_description'
        end
        field :exam_updates
        field :exam_sections
        field :start_date
        field :end_date
      end
    end

    private
    def check_to_and_from
      if self.end_date.present? && self.start_date.present? && self.end_date < self.start_date
        errors.add(:start_date, "can't be greater than end_date")
      end
    end
  end
end
