# == Schema Information
#
# Table name: user_assessments
#
#  id            :bigint           not null, primary key
#  attempt_count :integer
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
module BxBlockContentmanagement
  class UserAssessment < ApplicationRecord
    self.table_name = :user_assessments
    
    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :assessment, class_name: "BxBlockContentmanagement::Assessment"
    has_many :user_options, dependent: :destroy, class_name: "BxBlockContentmanagement::UserOption", as: :optionable
  end
end
