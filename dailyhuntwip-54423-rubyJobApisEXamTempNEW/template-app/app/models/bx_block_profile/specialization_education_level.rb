# == Schema Information
#
# Table name: specialization_education_levels
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  education_level_id :bigint
#  specialization_id  :bigint
#
# Indexes
#
#  index_specialization_education_levels_on_education_level_id  (education_level_id)
#  index_specialization_education_levels_on_specialization_id   (specialization_id)
#
module BxBlockProfile
	class SpecializationEducationLevel < ApplicationRecord
		self.table_name = :specialization_education_levels

		belongs_to :education_level
		belongs_to :specialization
	end
end
