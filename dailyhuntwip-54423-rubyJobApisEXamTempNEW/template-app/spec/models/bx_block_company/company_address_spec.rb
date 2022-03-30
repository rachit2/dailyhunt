require 'rails_helper'

RSpec.describe BxBlockCompany::CompanyAddress, type: :model do

  describe 'associations' do
    it { should belong_to(:company) }
  end

  describe 'validations' do
    it { should validate_presence_of(:address) }
  end

end
