# == Schema Information
#
# Table name: articles
#
#  id               :bigint           not null, primary key
#  content          :string
#  image            :string
#  publish_date     :datetime
#  status           :integer
#  title            :string
#  view             :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  career_expert_id :integer
#  category_id      :integer
#
class BxBlockExperts::Article < ApplicationRecord
  self.table_name = :articles
  mount_uploader :image, ImageUploader
  belongs_to :career_expert, class_name:"BxBlockExperts::CareerExpert"
  validates :title,:content,  presence: true
  belongs_to :category, class_name:"BxBlockCategories::Category"
  acts_as_taggable_on :tags
  enum status: ["draft", "publish"]
  validates :publish_date, presence: true, if: ->{ self.publish? }
  scope :published, -> {publish.where("publish_date < ?", DateTime.current)}
end
