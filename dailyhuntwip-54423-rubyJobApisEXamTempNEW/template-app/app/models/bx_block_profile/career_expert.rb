# == Schema Information
#
# Table name: career_experts
#
#  id          :bigint           not null, primary key
#  description :string
#  designation :string
#  heading     :string
#  image       :string
#  name        :string
#  price       :decimal(, )
#  rating      :integer
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockProfile
  class CareerExpert < ApplicationRecord
    self.table_name=:career_experts
    has_one :image, as: :attached_item, dependent: :destroy
    has_many :ratings, as: :reviewable, class_name: 'BxBlockContentmanagement::Rating', dependent: :destroy
    validates :name, :description, :designation, :status, :price,  presence: true

  end
end
