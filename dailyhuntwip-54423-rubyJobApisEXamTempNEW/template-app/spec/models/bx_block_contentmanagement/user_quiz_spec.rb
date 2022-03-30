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
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::UserQuiz, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:quiz) }
    it { should have_many(:user_options) }
  end
end
