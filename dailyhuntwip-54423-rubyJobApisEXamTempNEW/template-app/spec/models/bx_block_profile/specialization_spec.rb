# == Schema Information
#
# Table name: specializations
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  rank                      :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  degree_id                 :bigint
#  higher_education_level_id :bigint
#
require 'rails_helper'

RSpec.describe BxBlockProfile::Specialization, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:degree).optional }
    it { should have_many(:specialization_education_levels).class_name('BxBlockProfile::SpecializationEducationLevel').dependent(:destroy) }
  end
end
