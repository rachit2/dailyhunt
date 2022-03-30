# == Schema Information
#
# Table name: epubs
#
#  id          :bigint           not null, primary key
#  description :text
#  heading     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Epub, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:heading) }
    it { should have_many(:pdfs).dependent(:destroy) }
    it { should accept_nested_attributes_for(:pdfs).allow_destroy(true) }

  end
end
