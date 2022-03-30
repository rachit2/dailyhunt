# == Schema Information
#
# Table name: live_streams
#
#  id          :bigint           not null, primary key
#  description :string
#  headline    :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::LiveStream, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:headline) }
  end
end
