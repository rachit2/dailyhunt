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
module BxBlockProfile
  class ProfileSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :board,
      :completed_profile_categories,
      :cv,
      :school_name,
      :college_name,
      :competitive_exam_college_name,
      :standard,
      :subjects,
      :degree,
      :specialization,
      :educational_course,
      :college,
      :passing_year,
      :higher_education_level,
      :certifications,
      :employment_details,
      :govt_job_details,
      :competitive_exam_standard,
      :competitive_exam_board,
      :competitive_exam_school_name,
      :competitive_exam_degree,
      :competitive_exam_specialization,
      :competitive_exam_course,
      :competitive_exam_college,
      :competitive_exam_passing_year,
      :competitive_exam_subjects,
      :education_levels
    ]

    attributes :board do |object|
      BxBlockProfile::BoardSerializer.new(object.board) if object.board.present?
    end

    attributes :cv do |object|
      object.cv_url
    end

    attributes :govt_job_details do |object|
      BxBlockProfile::GovtJobSerializer.new(object.govt_job) if object.govt_job.present?
    end

    attributes :competitive_exam_standard do |object|
      BxBlockProfile::StandardSerializer.new(object.competitive_exam_standard) if object.competitive_exam_standard.present?
    end

    attributes :competitive_exam_board do |object|
      BxBlockProfile::BoardSerializer.new(object.competitive_exam_board) if object.competitive_exam_board.present?
    end

    attributes :competitive_exam_degree do |object|
      BxBlockProfile::DegreeSerializer.new(object.competitive_exam_degree) if object.competitive_exam_degree.present?
    end

    attributes :competitive_exam_specialization do |object|
      BxBlockProfile::SpecializationSerializer.new(object.competitive_exam_specialization) if object.competitive_exam_specialization.present?
    end

    attributes :competitive_exam_course do |object|
      BxBlockProfile::EducationalCourseSerializer.new(object.competitive_exam_course) if object.competitive_exam_course.present?
    end

    attributes :competitive_exam_college do |object|
      BxBlockProfile::CollegeSerializer.new(object.competitive_exam_college) if object.competitive_exam_college.present?
    end

    attributes :competitive_exam_subjects do |object|
      BxBlockProfile::SubjectSerializer.new(object.competitive_exam_subjects) if object.competitive_exam_subjects.present?
    end

    attributes :standard do |object|
      BxBlockProfile::StandardSerializer.new(object.standard) if object.standard.present?
    end

    attributes :subjects do |object|
      BxBlockProfile::SubjectSerializer.new(object.subjects) if object.subjects.present?
    end

    attributes :degree do |object|
      BxBlockProfile::DegreeSerializer.new(object.degree) if object.degree.present?
    end

    attributes :specialization do |object|
      BxBlockProfile::SpecializationSerializer.new(object.specialization) if object.specialization.present?
    end

    attributes :educational_course do |object|
      BxBlockProfile::EducationalCourseSerializer.new(object.educational_course) if object.educational_course.present?
    end

    attributes :college do |object|
      BxBlockProfile::CollegeSerializer.new(object.college) if object.college.present?
    end

    attributes :passing_year do |object|
      object.passing_year if object.passing_year != 0
    end

    attributes :higher_education_level do |object|
      BxBlockProfile::EducationLevelSerializer.new(object.higher_education_level) if object.higher_education_level.present?
    end

    attributes :certifications do |object|
      BxBlockProfile::CertificationSerializer.new(object.certifications)
    end

    attributes :employment_details do |object|
      BxBlockProfile::EmploymentDetailSerializer.new(object.employment_details)
    end

    attributes :education_levels do |object|
      BxBlockProfile::EducationLevelProfileSerializer.new(object.education_level_profiles)
    end

  end
end
