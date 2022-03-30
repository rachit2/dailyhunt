# == Schema Information
#
# Table name: educational_courses
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockProfile
  class EducationalCourse < ApplicationRecord
    self.table_name = :educational_courses 

    has_many :profiles, dependent: :nullify
    has_many :education_level_profiles, dependent: :nullify
    validates :name, uniqueness: true, presence:true
  end
end
