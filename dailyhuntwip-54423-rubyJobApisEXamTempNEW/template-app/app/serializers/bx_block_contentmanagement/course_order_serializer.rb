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
  class CourseOrderSerializer < BuilderBase::BaseSerializer
    attributes :id, :status, :account_id, :price, :courses, :created_at, :updated_at
    attribute :courses do |object|
      BxBlockContentmanagement::CourseSerializer.new(object.courses)
    end
  end
end
