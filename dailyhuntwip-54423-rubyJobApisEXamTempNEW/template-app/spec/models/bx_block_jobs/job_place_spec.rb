require 'rails_helper'

RSpec.describe BxBlockJobs::JobPlace, type: :model do

  describe 'associations' do
    it { should belong_to(:job) }
    it { should belong_to(:job_location) }
  end
end
