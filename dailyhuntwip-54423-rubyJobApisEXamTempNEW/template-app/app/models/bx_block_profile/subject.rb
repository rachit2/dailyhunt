# == Schema Information
#
# Table name: subjects
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockProfile
  class Subject < ApplicationRecord
    self.table_name = :subjects

    has_many :subject_profiles, class_name: 'BxBlockProfile::SubjectProfile', dependent: :destroy
    has_many :exam_subject_profiles, class_name: 'BxBlockProfile::ExamSubjectProfile', dependent: :destroy
    validates :name, uniqueness: true, presence:true
  end
end
