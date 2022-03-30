require 'rails_helper'

RSpec.describe BxBlockJobs::JobCategory, type: :model do
  describe 'associations' do
    it { should have_many(:jobs).class_name("BxBlockJobs::Job") }
    it { should have_many(:companies).class_name('BxBlockCompany::Company').through(:jobs) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

end
