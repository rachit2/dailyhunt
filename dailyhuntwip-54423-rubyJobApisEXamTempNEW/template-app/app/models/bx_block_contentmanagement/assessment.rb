# == Schema Information
#
# Table name: assessments
#
#  id                  :bigint           not null, primary key
#  description         :text
#  heading             :string
#  is_popular          :boolean
#  is_trending         :boolean
#  timer               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  category_id         :bigint
#  content_provider_id :integer
#  exam_id             :bigint
#  language_id         :bigint           not null
#  sub_category_id     :bigint
#
# Indexes
#
#  index_assessments_on_category_id      (category_id)
#  index_assessments_on_exam_id          (exam_id)
#  index_assessments_on_language_id      (language_id)
#  index_assessments_on_sub_category_id  (sub_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_id => exams.id)
#  fk_rails_...  (language_id => languages.id)
#
module BxBlockContentmanagement
  class Assessment < ApplicationRecord
    self.table_name = :assessments
    belongs_to :exam, class_name: "BxBlockContentmanagement::Exam", foreign_key: 'exam_id', optional: true
    belongs_to :category, class_name: 'BxBlockCategories::Category', foreign_key: 'category_id'
    belongs_to :sub_category, class_name: 'BxBlockCategories::SubCategory', foreign_key: 'sub_category_id'
    belongs_to :language, class_name: 'BxBlockLanguageoptions::Language'
    belongs_to :content_provider, class_name: 'BxBlockAdmin::AdminUser', foreign_key: :content_provider_id
    validates :heading, :description, presence: true
    has_many :test_questions, class_name: 'BxBlockContentmanagement::TestQuestion', dependent: :destroy, as: :questionable, inverse_of: :questionable
    has_many :banners, as: :bannerable, dependent: :destroy

    accepts_nested_attributes_for :test_questions, allow_destroy: true

    def name
      heading
    end

    rails_admin do
      edit do
        field :heading
        field :description
        field :language
        field :exam
        field :content_provider do
          associated_collection_scope do
            proc { |scope| scope.joins(:partner).where.not(partners: {id: nil}) }
          end
        end
        field :is_popular
        field :is_trending
        field :timer
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
        field :test_questions
      end
    end
  end
end
