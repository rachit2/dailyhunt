# == Schema Information
#
# Table name: ratings
#
#  id              :bigint           not null, primary key
#  rating          :integer
#  review          :string
#  reviewable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint
#  reviewable_id   :bigint
#
# Indexes
#
#  index_ratings_on_account_id                         (account_id)
#  index_ratings_on_reviewable_type_and_reviewable_id  (reviewable_type,reviewable_id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Rating, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:reviewable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:rating) }
    it { should validate_presence_of(:review) }
  end
end
