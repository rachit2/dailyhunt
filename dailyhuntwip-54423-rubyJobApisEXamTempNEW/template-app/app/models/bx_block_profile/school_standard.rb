# == Schema Information
#
# Table name: school_standards
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  school_id   :bigint           not null
#  standard_id :bigint           not null
#
# Indexes
#
#  index_school_standards_on_school_id    (school_id)
#  index_school_standards_on_standard_id  (standard_id)
#
# Foreign Keys
#
#  fk_rails_...  (school_id => schools.id)
#  fk_rails_...  (standard_id => standards.id)
#
class BxBlockProfile::SchoolStandard < ApplicationRecord
  self.table_name = :school_standards
  
  belongs_to :school
  belongs_to :standard
end
