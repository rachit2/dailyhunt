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
  class PaymentSerializer < BuilderBase::BaseSerializer
    attributes :id, :account_id, :price, :status, :order, :created_at, :updated_at
    attribute :order do |object|
      BxBlockContentmanagement::CourseOrderSerializer.new(object.course_order)
    end
  end
end
