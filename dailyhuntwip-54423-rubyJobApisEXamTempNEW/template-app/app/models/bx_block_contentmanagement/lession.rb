# == Schema Information
#
# Table name: lessions
#
#  id          :bigint           not null, primary key
#  description :text
#  heading     :string
#  rank        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :bigint           not null
#
# Indexes
#
#  index_lessions_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
module BxBlockContentmanagement
  class Lession < ApplicationRecord
    self.table_name = :lessions

    belongs_to :course, inverse_of: :lessions
    has_many :lession_contents, class_name: 'BxBlockContentmanagement::LessionContent', inverse_of: :lession
    accepts_nested_attributes_for :lession_contents, allow_destroy: true
    validates_presence_of :heading, :description

  end
end
