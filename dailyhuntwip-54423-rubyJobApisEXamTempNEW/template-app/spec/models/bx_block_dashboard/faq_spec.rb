# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :text
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockDashboard::Faq, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:question) }
    it { should validate_presence_of(:answer) }
  end
end
