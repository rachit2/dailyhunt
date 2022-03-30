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
#  language_id         :bigint           not null
#  sub_category_id     :bigint
#
# Indexes
#
#  index_assessments_on_category_id      (category_id)
#  index_assessments_on_language_id      (language_id)
#  index_assessments_on_sub_category_id  (sub_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
module BxBlockContentmanagement
  class AssessmentSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :timer, :description, :language, :content_provider, :is_popular, :is_trending, :created_at, :updated_at, :exam

    attribute :test_questions do |object|
      BxBlockContentmanagement::TestQuestionSerializer.new(object.test_questions)
    end
  end
end
