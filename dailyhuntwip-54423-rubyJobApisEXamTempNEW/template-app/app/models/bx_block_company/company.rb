# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  about      :string
#  logo       :string
#  name       :string
#  popular    :boolean
#  trending   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BxBlockCompany::Company < ApplicationRecord
  self.table_name = :companies
  mount_uploader :logo, ImageUploader
  has_many :company_job_positions, class_name: "BxBlockJobs::CompanyJobPosition", join_table:"company_job_positions", dependent: :destroy
  has_many :jobs, through: :company_job_positions, class_name:"BxBlockJobs::Job"
  has_many :account_jobs, class_name:"BxBlockJobs::AccountJob", dependent: :destroy
  acts_as_taggable_on :tags
  scope :trending_companies, -> { where(trending: true) }
  scope :popular_companies, -> { where(popular: true) }
  has_many :company_addresses
  has_many :bookmarks, class_name: "BxBlockContentmanagement::Bookmark", as: :bookmarkable, dependent: :destroy
  validates :name, :about, presence: true

  rails_admin do
    configure :contentable do
      label 'Headline'
    end
    field :name
    # field :company_addresses
    field :about
    field :popular
    field :trending
    field :logo
    field :tags do
      searchable [{ ActsAsTaggableOn::Tag => :name}]
      label "Tags"
      pretty_value do
        bindings[:object].tag_list
      end
    end
    # field :jobs do
    #   label "Positions"
    # end
  end

end
