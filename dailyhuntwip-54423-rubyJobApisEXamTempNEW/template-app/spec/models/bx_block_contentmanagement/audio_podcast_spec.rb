# == Schema Information
#
# Table name: audio_podcasts
#
#  id          :bigint           not null, primary key
#  description :string
#  heading     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'
RSpec.describe BxBlockContentmanagement::AudioPodcast, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:heading) }
  end
end
