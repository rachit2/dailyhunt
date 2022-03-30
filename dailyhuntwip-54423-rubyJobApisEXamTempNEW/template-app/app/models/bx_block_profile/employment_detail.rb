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
  class EmploymentDetail < ApplicationRecord
    self.table_name = :employment_details
    has_many :employment_detail_profiles, class_name: 'BxBlockProfile::EmploymentDetailProfile', dependent: :destroy

    belongs_to :domain_work_function, optional: true
    validates :last_employer, presence:true
  end
end
