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
#  cv                                 :string
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
  class Profile < ApplicationRecord
    self.table_name = :profiles

    mount_uploader :cv, PdfUploader
    PROFILE_FIELDS = {
      k12: [:board_id, :school_name, :standard_id],
      k12_hash_fields: [subject_ids: []],

      higher_education: [:degree_id, :specialization_id, :educational_course_id, :college_id, :college_name, :passing_year],
      higher_education_hash_fields: [],
      document:[:cv],
      competitive_exams: [:higher_education_level_id,
        :competitive_exam_degree_id, :competitive_exam_specialization_id, :competitive_exam_course_id, :competitive_exam_college_id, :competitive_exam_college_name, :competitive_exam_passing_year,
        :competitive_exam_board_id,  :competitive_exam_school_name, :competitive_exam_standard_id],
      competitive_exams_hash_fields: [competitive_exam_subject_ids: []],

      govt_job: [],
      govt_job_hash_fields: [govt_job_attributes: [:id, :education_level_id, :specialization_id, :caste_category, :_destroy]],

      upskilling: [],
      upskilling_hash_fields: [
        education_level_profiles_attributes: [:id, :education_level_id,
          :board_id, :specialization_id, :standard_id, :school_name, :_destroy,
          :degree_id, :college_id, :college_name, :educational_course_id, :passing_year, subject_ids:[]],
        certifications_attributes: [:id, :certification_course_name, :provided_by, :duration, :completion_year, :_destroy],
        employment_details_attributes: [:id, :last_employer, :designation, :domain_work_function_id, :_destroy]],
    }.freeze

    PROFILE_PARAMS = [
      *PROFILE_FIELDS[:document],
      *PROFILE_FIELDS[:k12],
      *PROFILE_FIELDS[:higher_education],
      *PROFILE_FIELDS[:competitive_exams],
      *PROFILE_FIELDS[:govt_job],
      *PROFILE_FIELDS[:upskilling],
      [
        *PROFILE_FIELDS[:k12_hash_fields],
        *PROFILE_FIELDS[:higher_education_hash_fields],
        *PROFILE_FIELDS[:competitive_exams_hash_fields],
        *PROFILE_FIELDS[:govt_job_hash_fields],
        *PROFILE_FIELDS[:upskilling_hash_fields],
        completed_profile_categories: [],
      ].inject(:merge),
    ].freeze

    # belongs_to
    belongs_to :account, class_name: 'AccountBlock::Account'

      # k12
      belongs_to :board, class_name: 'BxBlockProfile::Board',optional: true
      belongs_to :standard, class_name: 'BxBlockProfile::Standard', optional: true

      # higher_education
      belongs_to :degree, class_name: 'BxBlockProfile::Degree', optional: true
      belongs_to :specialization, class_name: 'BxBlockProfile::Specialization', optional: true
      belongs_to :educational_course, class_name: 'BxBlockProfile::EducationalCourse', optional: true
      belongs_to :college, class_name: 'BxBlockProfile::College', optional: true

      # competitive_exams
      belongs_to :higher_education_level, class_name: "BxBlockProfile::EducationLevel", foreign_key: "higher_education_level_id", optional: true
      belongs_to :competitive_exam_board, class_name: 'BxBlockProfile::Board',optional: true, foreign_key: :competitive_exam_board_id
      belongs_to :competitive_exam_college, class_name: 'BxBlockProfile::College', optional: true, foreign_key: :competitive_exam_college_id
      belongs_to :competitive_exam_degree, class_name: 'BxBlockProfile::Degree', optional: true, foreign_key: :competitive_exam_degree_id
      belongs_to :competitive_exam_specialization, class_name: 'BxBlockProfile::Specialization', optional: true, foreign_key: :competitive_exam_specialization_id
      belongs_to :competitive_exam_standard, class_name: 'BxBlockProfile::Standard', optional: true, foreign_key: :competitive_exam_standard_id
      belongs_to :competitive_exam_course, class_name: 'BxBlockProfile::EducationalCourse', optional: true, foreign_key: :competitive_exam_course_id

    # has_one
      # govt_job
      has_one :govt_job, class_name: "BxBlockProfile::GovtJob", dependent: :destroy

    # has_many
      # k12
      has_many :subject_profiles, class_name: 'BxBlockProfile::SubjectProfile', dependent: :destroy

      # competitive_exams
      has_many :exam_subject_profiles, class_name: 'BxBlockProfile::ExamSubjectProfile', dependent: :destroy

      # upskilling
      has_many :certification_profiles, class_name: 'BxBlockProfile::CertificationProfile', dependent: :destroy
      has_many :employment_detail_profiles, class_name: 'BxBlockProfile::EmploymentDetailProfile', dependent: :destroy
      has_many :education_level_profiles, class_name: 'BxBlockProfile::EducationLevelProfile', dependent: :destroy

    # has_many through
      # k12
      has_many :subjects, class_name: 'BxBlockProfile::Subject', through: :subject_profiles

      # competitive_exams
      has_many :competitive_exam_subjects, class_name: 'BxBlockProfile::Subject', through: :exam_subject_profiles, source: :subject

      # upskilling
      has_many :employment_details, class_name: 'BxBlockProfile::EmploymentDetail', through: :employment_detail_profiles
      has_many :certifications, class_name: 'BxBlockProfile::Certification', through: :certification_profiles
      has_many :education_levels, class_name: 'BxBlockProfile::EducationLevel', through: :education_level_profiles

    # accepts_nested_attributes_for
    accepts_nested_attributes_for :education_level_profiles, allow_destroy: true
    accepts_nested_attributes_for :certifications, allow_destroy: true
    accepts_nested_attributes_for :employment_details, allow_destroy: true
    accepts_nested_attributes_for :govt_job, allow_destroy: true


    def k12?
      account.categories.any? {|cat| cat.k12?}
    end

    def higher_education?
      account.categories.any? {|cat| cat.higher_education?}
    end

    def govt_job?
      account.categories.any? {|cat| cat.govt_job?}
    end

    def competitive_exams?
      account.categories.any? {|cat| cat.competitive_exams?}
    end

    def upskilling?
      account.categories.any? {|cat| cat.upskilling?}
    end

    def clear_fields_for(category_identifiers)
      category_identifiers.each do |category_identifier|
        send("clear_#{category_identifier}_fields")
      end
      save
    end

    def clear_direct_fields_for(category_identifier)
      PROFILE_FIELDS[category_identifier.to_sym].each do |field|
        self.send("#{field}=", nil)
      end
    end

    def clear_k12_fields
      clear_direct_fields_for(:k12)
      self.subject_profiles = []
    end

    def clear_higher_education_fields
      clear_direct_fields_for(:higher_education)
    end

    def clear_govt_job_fields
      clear_direct_fields_for(:govt_job)
      self.govt_job = nil
    end

    def clear_competitive_exams_fields
      clear_direct_fields_for(:competitive_exams)
      self.exam_subject_profiles = []
    end

    def clear_upskilling_fields
      clear_direct_fields_for(:upskilling)
      self.certification_profiles = []
      self.employment_detail_profiles = []
      self.education_level_profiles = []
    end
  end
end
