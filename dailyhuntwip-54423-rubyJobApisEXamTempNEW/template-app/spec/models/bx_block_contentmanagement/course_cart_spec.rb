require 'rails_helper'

RSpec.describe BxBlockContentmanagement::CourseCart, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should have_many(:cart_courses) }
    it { should have_many(:courses).through(:cart_courses) }
  end
end
