# == Schema Information
#
# Table name: lession_contents
#
#  id           :bigint           not null, primary key
#  content_type :integer
#  description  :text
#  duration     :string
#  file_content :string
#  heading      :string
#  is_free      :boolean          default(FALSE)
#  rank         :integer
#  thumbnail    :string
#  video        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lession_id   :bigint           not null
#
# Indexes
#
#  index_lession_contents_on_lession_id  (lession_id)
#
# Foreign Keys
#
#  fk_rails_...  (lession_id => lessions.id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::LessionContent, type: :model do
  describe 'associations' do
    it { should belong_to(:lession) }
  end
end
