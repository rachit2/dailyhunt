require 'rails_helper'

RSpec.describe BxBlockCompany::Company, type: :model do
  describe 'associations' do
    it { should have_many(:company_job_positions).class_name("BxBlockJobs::CompanyJobPosition").dependent(:destroy) }
    it { should have_many(:jobs).through(:job_places).class_name("BxBlockJobs::Job").through(:company_job_positions) }
    it { should have_many(:company_addresses) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:about) }
  end
end
