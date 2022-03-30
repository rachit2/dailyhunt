# == Schema Information
#
# Table name: profiles
#
#  id                                 :bigint           not null, primary key
#  college_name                       :string
#  competitive_exam_college_name      :string
#  competitive_exam_passing_year      :string
#  competitive_exam_school_name       :string
#  completed_profile_categories       :string           default([]), is an Array
#  passing_year                       :integer
#  school_name                        :string
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  account_id                         :bigint
#  board_id                           :bigint
#  college_id                         :bigint
#  competitive_exam_board_id          :bigint
#  competitive_exam_college_id        :bigint
#  competitive_exam_course_id         :bigint
#  competitive_exam_degree_id         :bigint
#  competitive_exam_specialization_id :bigint
#  competitive_exam_standard_id       :bigint
#  degree_id                          :bigint
#  educational_course_id              :bigint
#  higher_education_level_id          :bigint
#  specialization_id                  :bigint
#  standard_id                        :bigint
#
# Indexes
#
#  index_profiles_on_account_id             (account_id)
#  index_profiles_on_board_id               (board_id)
#  index_profiles_on_college_id             (college_id)
#  index_profiles_on_degree_id              (degree_id)
#  index_profiles_on_educational_course_id  (educational_course_id)
#  index_profiles_on_specialization_id      (specialization_id)
#  index_profiles_on_standard_id            (standard_id)
#
# Foreign Keys
#
#  fk_rails_...  (board_id => boards.id)
#  fk_rails_...  (college_id => colleges.id)
#  fk_rails_...  (degree_id => degrees.id)
#  fk_rails_...  (educational_course_id => educational_courses.id)
#  fk_rails_...  (specialization_id => specializations.id)
#  fk_rails_...  (standard_id => standards.id)
#
require 'rails_helper'

RSpec.describe BxBlockProfile::Profile, type: :model do
  context 'validate profile params' do
    let(:expected_profile_params) { [:board_id, :school_name, :standard_id, :degree_id, :specialization_id, :educational_course_id, :college_id, :college_name, :competitive_exam_college_name,:competitive_exam_standard_id, :competitive_exam_board_id, :competitive_exam_school_name, :competitive_exam_degree_id, :competitive_exam_specialization_id, :competitive_exam_course_id, :competitive_exam_college_id, :competitive_exam_passing_year,:passing_year, :higher_education_level_id, competitive_exam_subject_ids: [],completed_profile_categories: [],subject_ids: [], education_level_profiles_attributes: [:id, :education_level_id, :board_id, :specialization_id, :standard_id, :school_name, :_destroy, :degree_id, :college_id, :college_name, :educational_course_id, :passing_year, subject_ids:[]], certifications_attributes: [:id, :certification_course_name, :provided_by, :duration, :completion_year, :_destroy], employment_details_attributes: [:id, :last_employer, :designation, :domain_work_function_id, :_destroy], govt_job_attributes: [:id, :education_level_id, :specialization_id, :caste_category, :_destroy]] }

    it 'Should define PROFILE_PARAMS correctly' do
      expect(BxBlockProfile::Profile::PROFILE_PARAMS).to match_array(expected_profile_params)
    end
  end


end
