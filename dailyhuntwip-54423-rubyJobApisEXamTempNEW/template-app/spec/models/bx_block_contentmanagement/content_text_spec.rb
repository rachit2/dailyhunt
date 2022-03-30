# == Schema Information
#
# Table name: content_texts
#
#  id          :bigint           not null, primary key
#  headline    :string
#  content     :string
#  hyperlink   :string
#  affiliation :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::ContentText, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:headline) }
    it { should validate_presence_of(:content) }
    it { should have_many(:images).dependent(:destroy) }
    it { should have_many(:videos).class_name('BxBlockVideos::Video').dependent(:destroy) }
    it { should accept_nested_attributes_for(:images).allow_destroy(true) }
    it { should accept_nested_attributes_for(:videos).allow_destroy(true) }
  end
end
