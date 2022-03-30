class Order < ApplicationRecord
  belongs_to :account, class_name: 'AccountBlock::Account'
  has_many :order_courses, class_name: 'BxBlockContentmanagement::OrderCourse', dependent: :destroy, foreign_key: :order_id
  has_many :courses, class_name: 'BxBlockContentmanagement::Course', through: :order_courses
  has_one :payment, class_name: 'BxBlockContentmanagement::Payment', through: :payment, foreign_key: :order_id

  validates :courses, :status, :price, presence: true
  enum status: ["pending", "paid"]

end
