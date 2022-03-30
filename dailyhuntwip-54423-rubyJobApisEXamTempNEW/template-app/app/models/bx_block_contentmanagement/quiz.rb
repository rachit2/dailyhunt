# == Schema Information
#
# Table name: quizzes
#
#  id                  :bigint           not null, primary key
#  description         :text
#  heading             :string
#  is_popular          :boolean
#  is_trending         :boolean
#  quiz_description    :text
#  timer               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  category_id         :bigint
#  content_provider_id :integer
#  language_id         :bigint           not null
#  sub_category_id     :bigint
#
# Indexes
#
#  index_quizzes_on_category_id      (category_id)
#  index_quizzes_on_language_id      (language_id)
#  index_quizzes_on_sub_category_id  (sub_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
module BxBlockContentmanagement
  class Quiz < ApplicationRecord
    self.table_name = :quizzes

    belongs_to :category, class_name: 'BxBlockCategories::Category', foreign_key: 'category_id'
    belongs_to :sub_category, class_name: 'BxBlockCategories::SubCategory', foreign_key: 'sub_category_id'

    belongs_to :language, class_name: 'BxBlockLanguageoptions::Language'
    belongs_to :content_provider, class_name: 'BxBlockAdmin::AdminUser', foreign_key: :content_provider_id, optional: true

    validates :heading, :description, :quiz_description, :timer,presence: true
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
        field :quiz_description
        field :language
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
