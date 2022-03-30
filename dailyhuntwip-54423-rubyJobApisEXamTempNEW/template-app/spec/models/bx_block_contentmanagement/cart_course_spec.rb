require 'rails_helper'

RSpec.describe BxBlockContentmanagement::CartCourse, type: :model do
  describe 'associations' do
    it { should belong_to(:course_cart) }
    it { should belong_to(:course) }
  end
end
