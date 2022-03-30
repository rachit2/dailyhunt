# == Schema Information
#
# Table name: education_levels
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  level      :integer
#
require 'rails_helper'

RSpec.describe BxBlockProfile::EducationLevel, type: :model do
  describe 'associations' do
    it { should have_many(:education_level_profiles).dependent(:destroy) }
    it { should have_many(:specialization_education_levels).dependent(:destroy) }
    it { should have_many(:specializations) }
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
