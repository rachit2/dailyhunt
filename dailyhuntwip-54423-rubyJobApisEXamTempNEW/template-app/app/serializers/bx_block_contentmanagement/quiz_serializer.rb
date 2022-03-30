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
  class QuizSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :description, :quiz_description, :language, :content_provider, :timer, :test_questions,:is_popular, :is_trending, :created_at, :updated_at

    attribute :language do |object|
      BxBlockLanguageoptions::LanguageSerializer.new(object.language)
    end 

    attribute :test_questions do |object|
      BxBlockContentmanagement::TestQuestionSerializer.new(object.test_questions)
    end

    attribute :attempt_count do |object, params|
      if params[:current_user_id].present?
        user_quiz = UserQuiz.where(account_id: params[:current_user_id], quiz_id: object.id)&.first
        user_quiz.attempt_count if user_quiz.present?
      end
    end
  end
end
