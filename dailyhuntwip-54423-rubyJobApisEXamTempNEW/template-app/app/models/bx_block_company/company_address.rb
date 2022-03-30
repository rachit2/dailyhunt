# == Schema Information
#
# Table name: company_addresses
#
#  id         :bigint           not null, primary key
#  address    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#
class BxBlockCompany::CompanyAddress < ApplicationRecord
  self.table_name = :company_addresses
  belongs_to :company
  validates :address, presence: true
end
