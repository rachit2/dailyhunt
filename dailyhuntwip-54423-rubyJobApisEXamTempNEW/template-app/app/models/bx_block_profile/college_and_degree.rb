# == Schema Information
#
# Table name: college_and_degrees
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  college_id :bigint           not null
#  degree_id  :bigint           not null
#
# Indexes
#
#  index_college_and_degrees_on_college_id  (college_id)
#  index_college_and_degrees_on_degree_id   (degree_id)
#
# Foreign Keys
#
#  fk_rails_...  (college_id => colleges.id)
#  fk_rails_...  (degree_id => degrees.id)
#
class BxBlockProfile::CollegeAndDegree < ApplicationRecord
	self.table_name = :college_and_degrees

  belongs_to :college
  belongs_to :degree
end
