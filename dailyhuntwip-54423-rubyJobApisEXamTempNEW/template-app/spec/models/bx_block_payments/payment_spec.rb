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
require 'rails_helper'

RSpec.describe BxBlockPayments::Payment, type: :model do
  describe 'associations' do
    it { should belong_to(:course_order).class_name('BxBlockContentmanagement::CourseOrder') }
  end
end
