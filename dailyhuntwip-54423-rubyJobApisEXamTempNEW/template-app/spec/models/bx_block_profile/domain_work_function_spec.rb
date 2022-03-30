# == Schema Information
#
# Table name: domain_work_functions
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockProfile::DomainWorkFunction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
