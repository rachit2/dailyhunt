# == Schema Information
#
# Table name: user_assessments
#
#  id            :bigint           not null, primary key
#  rank          :integer
#  total         :integer
#  tracker       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint           not null
#  assessment_id :bigint           not null
#
# Indexes
#
#  index_user_assessments_on_account_id     (account_id)
#  index_user_assessments_on_assessment_id  (assessment_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (assessment_id => assessments.id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::UserAssessment, type: :model do

  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account')  }
    it { should belong_to(:assessment).class_name('BxBlockContentmanagement::Assessment')  }
    it { should have_many(:user_options).class_name('BxBlockContentmanagement::UserOption').dependent(:destroy) }
  end
end
