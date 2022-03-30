# == Schema Information
#
# Table name: educational_courses
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockProfile::EducationalCourse, type: :model do
  describe 'associations' do
    it { should have_many(:profiles).dependent(:nullify) }
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
