# == Schema Information
#
# Table name: employment_details
#
#  id                      :bigint           not null, primary key
#  last_employer           :string
#  designation             :string
#  rank                    :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  domain_work_function_id :bigint
#
module BxBlockExperts
  class AccountExpertSerializer < BuilderBase::BaseSerializer
    attributes *[
      :id,
      :account,
      :career_expert,
      :mode
    ]
  end
end
