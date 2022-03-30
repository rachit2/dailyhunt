# == Schema Information
#
# Table name: user_quizzes
#
#  id            :bigint           not null, primary key
#  attempt_count :integer
#  rank          :integer
#  total         :integer
#  tracker       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint           not null
#  quiz_id       :bigint           not null
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
  class UserQuiz < ApplicationRecord
    self.table_name = :user_quizzes
    
    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :quiz
    has_many :user_options, dependent: :destroy, class_name: "BxBlockContentmanagement::UserOption", as: :optionable
  end
end
