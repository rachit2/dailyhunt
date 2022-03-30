# == Schema Information
#
# Table name: colleges
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_others  :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe BxBlockProfile::College, type: :model do
  describe 'associations' do
    it { should have_many(:profiles).dependent(:nullify) }
  end
  describe 'validations' do
    let(:location) { BxBlockProfile::Location.create!(name:"a", latitude:12.2, longitude:13.2) }
    let(:university) {BxBlockProfile::University.create!(name:"a", location:location)}
    subject { BxBlockProfile::College.new(university: university, location:location) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
