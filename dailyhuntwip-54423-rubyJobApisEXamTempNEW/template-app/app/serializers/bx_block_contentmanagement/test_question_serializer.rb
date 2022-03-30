# == Schema Information
#
# Table name: test_questions
#
#  id                :bigint           not null, primary key
#  question          :string
#  options_number    :integer
#  questionable_id   :integer
#  questionable_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
module BxBlockContentmanagement
  class TestQuestionSerializer < BuilderBase::BaseSerializer
    attributes :id, :question, :options_number, :options

    attribute :options do |object|
      object.options.select(:id, :answer)
    end

    attribute :correct_answer do |object|
      object.correct_ans
    end

    attribute :choosen_answer do |object, params|
      choosen_answer(object.questionable_id, object.id, params[:current_user_id]) if params[:current_user_id].present?
    end

    class << self
      private

      def choosen_answer(assessment_id, question_id, current_user_id)
        user_assessment = BxBlockContentmanagement::UserAssessment.where(account_id: current_user_id, assessment_id: assessment_id)&.first
        user_assessment.user_options.find_by(test_question_id: question_id)&.option if user_assessment.present?
      end
    end
  end
end
