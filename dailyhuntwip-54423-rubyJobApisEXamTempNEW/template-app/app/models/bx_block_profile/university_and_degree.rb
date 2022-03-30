# == Schema Information
#
# Table name: bx_block_profile_university_and_degrees
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  degree_id     :bigint           not null
#  university_id :bigint           not null
#
# Indexes
#
#  index_bx_block_profile_university_and_degrees_on_degree_id      (degree_id)
#  index_bx_block_profile_university_and_degrees_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (degree_id => degrees.id)
#  fk_rails_...  (university_id => universities.id)
#
class BxBlockProfile::UniversityAndDegree < ApplicationRecord
  belongs_to :university
  belongs_to :degree
end
