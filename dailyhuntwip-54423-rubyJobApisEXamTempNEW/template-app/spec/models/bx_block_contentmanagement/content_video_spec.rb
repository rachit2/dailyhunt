# == Schema Information
#
# Table name: content_videos
#
#  id               :bigint           not null, primary key
#  separate_section :string
#  headline         :string
#  description      :string
#  thumbnails       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::ContentVideo, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:headline) }
    it { should have_one(:video).class_name('BxBlockVideos::Video').dependent(:destroy) }
    it { should accept_nested_attributes_for(:video).allow_destroy(true) }
    it { should have_one(:image).dependent(:destroy) }
    it { should accept_nested_attributes_for(:image).allow_destroy(true) }

  end
end
