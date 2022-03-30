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
require 'rails_helper'

RSpec.describe BxBlockProfile::EmploymentDetail, type: :model do
  describe 'associations' do
    it { should belong_to(:domain_work_function).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:last_employer) }
  end
end
