# == Schema Information
#
# Table name: total_fees
#
#  id         :bigint           not null, primary key
#  is_active  :boolean
#  max        :bigint
#  min        :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockProfile
	class TotalFee < ApplicationRecord
    self.table_name = :total_fees

    scope :active, -> { where(is_active: true) }
	end
end
