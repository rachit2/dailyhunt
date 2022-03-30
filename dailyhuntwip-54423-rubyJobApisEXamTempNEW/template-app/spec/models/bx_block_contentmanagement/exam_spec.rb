# == Schema Information
#
# Table name: exams
#
#  id              :bigint           not null, primary key
#  description     :text
#  from            :date
#  heading         :string
#  thumbnail       :string
#  to              :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  category_id     :bigint
#  sub_category_id :bigint
#
# Indexes
#
#  index_exams_on_category_id      (category_id)
#  index_exams_on_sub_category_id  (sub_category_id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Exam, type: :model do
  describe 'associations' do
    it { should belong_to(:category).class_name('BxBlockCategories::Category') }
    it { should belong_to(:sub_category).class_name('BxBlockCategories::SubCategory') }
  end

  describe 'validations' do
    it { should validate_presence_of(:heading) }
    it { should validate_presence_of(:to) }
    it { should validate_presence_of(:from) }
  end
end
