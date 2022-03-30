# == Schema Information
#
# Table name: videos
#
#  id                 :bigint           not null, primary key
#  attached_item_type :string
#  video              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attached_item_id   :integer
#
# Indexes
#
#  index_videos_on_attached_item_id    (attached_item_id)
#  index_videos_on_attached_item_type  (attached_item_type)
#
require 'rails_helper'

RSpec.describe BxBlockVideos::Video, type: :model do
  describe 'associations' do
    it { should belong_to(:attached_item) }
  end

  describe 'validations' do
    it { should validate_presence_of(:video) }
  end
end
