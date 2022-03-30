# == Schema Information
#
# Table name: domain_work_functions
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockProfile
  class DomainWorkFunction < ApplicationRecord
    self.table_name = :domain_work_functions

    validates :name, presence: true
  end
end
