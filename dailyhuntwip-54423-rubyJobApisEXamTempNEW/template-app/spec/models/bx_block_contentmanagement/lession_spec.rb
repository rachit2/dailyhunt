# == Schema Information
#
# Table name: lessions
#
#  id          :bigint           not null, primary key
#  description :text
#  heading     :string
#  rank        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :bigint           not null
#
# Indexes
#
#  index_lessions_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Lession, type: :model do
  describe 'associations' do
    it { should belong_to(:course) }
    it { should have_many(:lession_contents) }
  end
  describe 'validations' do
    it { should validate_presence_of(:heading) }
    it { should validate_presence_of(:description) }
  end
end
