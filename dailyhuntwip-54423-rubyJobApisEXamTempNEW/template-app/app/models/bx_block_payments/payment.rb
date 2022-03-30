# == Schema Information
#
# Table name: payments
#
#  id              :bigint           not null, primary key
#  price           :integer
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint           not null
#  course_order_id :bigint           not null
#
# Indexes
#
#  index_payments_on_account_id       (account_id)
#  index_payments_on_course_order_id  (course_order_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (course_order_id => course_orders.id)
#
module BxBlockPayments
  class Payment < ApplicationRecord
    self.table_name = :payments

    belongs_to :course_order, class_name: 'BxBlockContentmanagement::CourseOrder'
    enum status: ["pending", "paid"]
    validates :course_order, uniqueness: { scope: :account_id }

    after_create :update_order

    private

    def update_order
      course_order.update(status: 'paid')
    end

  end
end
