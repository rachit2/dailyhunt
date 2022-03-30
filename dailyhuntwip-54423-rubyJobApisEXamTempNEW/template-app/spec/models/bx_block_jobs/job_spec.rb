require 'rails_helper'

RSpec.describe BxBlockJobs::Job, type: :model do

  describe 'associations' do
    it { should belong_to(:job_category).class_name('BxBlockJobs::JobCategory') }
    it { should belong_to(:sub_category).class_name('BxBlockCategories::SubCategory').optional }
    it { should have_and_belong_to_many(:accounts).class_name('AccountBlock::Account') }
    it { should have_many(:company_job_positions).class_name('BxBlockJobs::CompanyJobPosition').dependent(:destroy) }
    it { should have_many(:job_places).dependent(:destroy) }
    it { should have_many(:job_locations).through(:job_places) }
    it { should have_many(:companies).class_name('BxBlockCompany::Company').through(:company_job_positions) }

  end

  describe 'validations' do
    it { should define_enum_for(:job_type).with_values(['parttime', 'fulltime', 'internship', 'remote']) }
    it { should define_enum_for(:experience).with_values(['0-2yrs', '2-4yrs', '4-8yrs', '8-16yrs']) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:job_type) }
    it { should validate_presence_of(:experience) }
  end

end
