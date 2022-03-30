# == Schema Information
#
# Table name: authors
#
#  id         :bigint           not null, primary key
#  name       :string
#  bio        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Author, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:bio) }
    it { should validate_length_of(:bio).is_at_most(500).with_message(/should not greater then/) }
  end

  describe 'associations' do
  	it { should have_many(:contents).class_name('BxBlockContentmanagement::Content').dependent(:destroy) }
  	it { should have_one(:image).dependent(:destroy) }
  end
  
end
