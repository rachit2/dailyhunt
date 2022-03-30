# == Schema Information
#
# Table name: degrees
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockProfile
  class Degree < ApplicationRecord
    self.table_name = :degrees

    has_many :specializations
    validates :name, uniqueness: true, presence:true
    has_many :profiles, dependent: :nullify
    has_many :education_level_profiles, dependent: :nullify

  end
end
