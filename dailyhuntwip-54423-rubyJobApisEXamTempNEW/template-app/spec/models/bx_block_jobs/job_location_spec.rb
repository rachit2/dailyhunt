require 'rails_helper'

RSpec.describe BxBlockJobs::JobLocation, type: :model do

  describe 'associations' do
    it { should have_many(:job_places).class_name("BxBlockJobs::JobPlace") }
    it { should have_many(:jobs).through(:job_places).class_name("BxBlockJobs::Job") }
  end

  describe 'validations' do
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:city) }
  end

end
