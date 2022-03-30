# == Schema Information
#
# Table name: course_carts
#
#  id         :bigint           not null, primary key
#  price      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#
# Indexes
#
#  index_course_carts_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
module BxBlockContentmanagement
  class CourseCart < ApplicationRecord
    belongs_to :account, class_name: 'AccountBlock::Account'
    has_many :cart_courses, dependent: :destroy
    has_many :courses, through: :cart_courses

    validates :courses, presence: true
  end
end
