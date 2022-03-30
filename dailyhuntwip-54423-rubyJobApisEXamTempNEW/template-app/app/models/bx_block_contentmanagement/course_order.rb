# == Schema Information
#
# Table name: course_orders
#
#  id         :bigint           not null, primary key
#  price      :integer
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#
# Indexes
#
#  index_course_orders_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
module BxBlockContentmanagement
  class CourseOrder < ApplicationRecord
    self.table_name = :course_orders

    belongs_to :account, class_name: 'AccountBlock::Account'
    has_many :order_courses, class_name: 'BxBlockContentmanagement::OrderCourse', dependent: :destroy
    has_many :courses, class_name: 'BxBlockContentmanagement::Course', through: :order_courses
    has_one :payment, class_name: 'BxBlockPayments::Payment'
    scope :paid, -> { where(status: 'paid') }

    validates :courses, :status, :price, presence: true
    enum status: ["pending", "paid"]

  end
end
