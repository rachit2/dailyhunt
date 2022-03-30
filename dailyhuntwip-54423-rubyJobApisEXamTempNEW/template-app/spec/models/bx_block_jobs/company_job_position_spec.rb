require 'rails_helper'

RSpec.describe BxBlockJobs::CompanyJobPosition, type: :model do

  describe 'associations' do
    it { should belong_to(:company).class_name('BxBlockCompany::Company') }
    it { should belong_to(:job).class_name('BxBlockJobs::Job') }
  end
end
