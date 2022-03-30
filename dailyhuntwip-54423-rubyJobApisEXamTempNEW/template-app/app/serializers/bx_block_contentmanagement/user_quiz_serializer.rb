# == Schema Information
#
# Table name: user_quizzes
#
#  id         :bigint           not null, primary key
#  rank       :integer
#  total      :integer
#  tracker    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  quiz_id    :bigint           not null
#
# Indexes
#
#  index_user_quizzes_on_account_id  (account_id)
#  index_user_quizzes_on_quiz_id     (quiz_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (quiz_id => quizzes.id)
#
module BxBlockContentmanagement
  class UserQuizSerializer < BuilderBase::BaseSerializer
    attributes :id, :quiz, :account, :obtained_marks, :attempt_count, :rank, :total_marks

    attribute :rank do |object|
      UserOption::rank('quiz', object)
    end

    attribute :obtained_marks do |object|
      object.total.to_i
    end

    attribute :total_marks do |object|
      object.quiz.test_questions.count
    end

  end
end
