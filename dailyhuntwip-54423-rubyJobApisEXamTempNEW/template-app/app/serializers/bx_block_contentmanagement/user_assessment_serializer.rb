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
module BxBlockContentmanagement
  class UserAssessmentSerializer < BuilderBase::BaseSerializer
    attributes :id, :assessment, :account, :attempt_count, :rank

    attribute :rank do |object|
      UserOption::rank('assessment', object)
    end

    attribute :obtained_marks do |object|
      object.total
    end

    attribute :total_marks do |object|
      object.assessment.test_questions.count
    end
  end
end
