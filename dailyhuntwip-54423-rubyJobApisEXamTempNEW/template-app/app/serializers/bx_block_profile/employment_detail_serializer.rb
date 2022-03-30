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
module BxBlockProfile
  class EmploymentDetailSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :last_employer,
      :designation,
      :domain_work_function
    ]

    attributes :domain_work_function do |object|
      object.domain_work_function if object.domain_work_function.present?
    end

  end
end
