# == Schema Information
#
# Table name: login_background_files
#
#  id                    :bigint           not null, primary key
#  attached_item_type    :string
#  login_background_file :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  attached_item_id      :integer
#
# Indexes
#
#  index_login_background_files_on_attached_item_id    (attached_item_id)
#  index_login_background_files_on_attached_item_type  (attached_item_type)
#
require 'rails_helper'

RSpec.describe LoginBackgroundFile, type: :model do
  describe 'associations' do
    it { should belong_to(:attached_item) }
  end

  describe 'validations' do
    it { should validate_presence_of(:login_background_file) }
  end
end
