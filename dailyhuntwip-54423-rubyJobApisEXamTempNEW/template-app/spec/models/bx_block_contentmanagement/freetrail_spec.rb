# == Schema Information
#
# Table name: freetrails
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint
#  course_id  :bigint
#
# Indexes
#
#  index_freetrails_on_account_id  (account_id)
#  index_freetrails_on_course_id   (course_id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Freetrail, type: :model do
  describe 'associations' do
    it { should belong_to(:course).class_name('BxBlockContentmanagement::Course') }
  end
end
