# == Schema Information
#
# Table name: instructors
#
#  id         :bigint           not null, primary key
#  name       :string
#  bio        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Instructor, type: :model do
  describe 'associations' do
    it { should have_many(:course_instructors).class_name('BxBlockContentmanagement::CourseInstructor') }
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:bio) }
  end
end
