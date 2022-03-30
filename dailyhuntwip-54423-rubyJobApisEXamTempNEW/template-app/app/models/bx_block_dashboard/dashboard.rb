# == Schema Information
#
# Table name: dashboards
#
#  id         :bigint           not null, primary key
#  title      :string
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockDashboard
  class Dashboard < BxBlockDashboard::ApplicationRecord
    self.table_name = :dashboards
  end
end

