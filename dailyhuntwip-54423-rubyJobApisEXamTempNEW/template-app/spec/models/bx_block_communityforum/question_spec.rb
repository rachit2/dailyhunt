# == Schema Information
#
# Table name: questions
#
#  id              :bigint           not null, primary key
#  closed          :boolean
#  description     :text
#  image           :string
#  status          :integer
#  title           :string
#  view            :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint
#  sub_category_id :bigint
#
# Indexes
#
#  index_questions_on_account_id       (account_id)
#  index_questions_on_sub_category_id  (sub_category_id)
#
require 'rails_helper'

RSpec.describe BxBlockCommunityforum::Question, type: :model do

  describe 'associations' do
    it { should have_many(:answers).class_name('BxBlockCommunityforum::Answer').dependent(:destroy) }
    it { should have_many(:votes).class_name('BxBlockCommunityforum::Vote').dependent(:destroy) }
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:sub_category).class_name('BxBlockCategories::SubCategory').dependent(:destroy) }
    it { should have_many(:comments).class_name('BxBlockCommunityforum::Comment') }
    it { should have_many(:likes).class_name('BxBlockCommunityforum::Like') }

    it { should define_enum_for(:status).with_values(["draft", "publish"]) }
  end
  
end
