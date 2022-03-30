# == Schema Information
#
# Table name: banners
#
#  id              :bigint           not null, primary key
#  bannerable_type :string
#  end_time        :datetime
#  image           :string
#  is_explore      :boolean
#  rank            :integer
#  start_time      :datetime
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  bannerable_id   :integer
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Banner, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
