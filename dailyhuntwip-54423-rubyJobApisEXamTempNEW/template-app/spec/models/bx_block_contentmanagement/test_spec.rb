# == Schema Information
#
# Table name: tests
#
#  id          :bigint           not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  headline    :string
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Test, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:description) }
  end
end
