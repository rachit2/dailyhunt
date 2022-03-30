require 'rails_helper'
# include StubHelper

RSpec.describe BxBlockProfile::School, type: :model do

  describe 'associations' do
    it { should belong_to(:location) }
    it { should belong_to(:city) }
    it { should belong_to(:board) }
    it { should have_one(:brochure).dependent(:destroy) }
    it { should have_many(:school_standards).class_name('BxBlockProfile::SchoolStandard').dependent(:destroy) }
    it { should have_many(:standards).class_name('BxBlockProfile::Standard').through(:school_standards) }
    it { should define_enum_for(:school_type).with_values(['Private','Private aided']) }
    it { should define_enum_for(:language_of_interaction).with_values(['English', 'Hindi']) }
    it { should define_enum_for(:admission_process).with_values(['Ongoing', 'Closed']) }
  end

  describe 'validations' do
    # let!(:location) { BxBlockProfile::Location.create!(name:"a", latitude:12.2, longitude:13.2) }
    # let!(:university) {BxBlockProfile::University.create!(name:"a", location:location)}
    # subject { BxBlockProfile::College.new(university: university, location:location) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

end
