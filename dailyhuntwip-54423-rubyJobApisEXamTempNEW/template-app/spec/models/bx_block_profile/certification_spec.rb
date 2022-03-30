# == Schema Information
#
# Table name: certifications
#
#  id                        :bigint           not null, primary key
#  certification_course_name :string
#  provided_by               :string
#  duration                  :integer
#  completion_year           :integer
#  rank                      :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockProfile::Certification, type: :model do
  describe 'associations' do
    it { should have_many(:certification_profiles).dependent(:destroy) }
  end
  describe 'validations' do
    it { should validate_presence_of(:certification_course_name) }
  end
end
