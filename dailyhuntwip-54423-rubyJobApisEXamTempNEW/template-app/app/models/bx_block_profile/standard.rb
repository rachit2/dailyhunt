# == Schema Information
#
# Table name: standards
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockProfile
  class Standard < ApplicationRecord
    self.table_name = :standards
    has_many :profiles, dependent: :nullify
    has_many :education_level_profiles, dependent: :nullify

    validates :name, uniqueness: true, presence:true
  end
end
