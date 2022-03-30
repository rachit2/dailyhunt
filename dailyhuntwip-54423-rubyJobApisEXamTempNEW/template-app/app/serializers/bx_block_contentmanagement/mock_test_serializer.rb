# == Schema Information
#
# Table name: quizzes
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
#  index_quizzes_on_category_id      (category_id)
#  index_quizzes_on_language_id      (language_id)
#  index_quizzes_on_sub_category_id  (sub_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
module BxBlockContentmanagement
  class MockTestSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :description, :exam, :pdf

    attribute :pdf do |object|

      object.pdf_url if object.pdf.present?
    end

  end
end
