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
require 'rails_helper'

RSpec.describe BxBlockProfile::SpecializationEducationLevel, type: :model do
  it { should belong_to(:education_level) }
  it { should belong_to(:specialization) }
end
