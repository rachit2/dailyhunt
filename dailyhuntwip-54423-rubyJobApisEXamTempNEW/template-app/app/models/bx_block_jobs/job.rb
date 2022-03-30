# == Schema Information
#
# Table name: jobs
#
#  id              :bigint           not null, primary key
#  description     :text
#  experience      :integer
#  heading         :string
#  job_type        :integer
#  name            :string
#  popular         :boolean
#  requirement     :text
#  trending        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  job_category_id :integer
#  job_type_id     :integer
#  sub_category_id :integer
#
module BxBlockJobs
  class Job < ApplicationRecord
  	self.table_name = :jobs
  	enum job_type: ['parttime', 'fulltime', 'internship', 'remote']
    enum experience: ['0-2yrs', '2-4yrs', '4-8yrs', '8-16yrs']
    enum date_posted:['any_time','past_month', 'past_week','last_24_hours']

    SALARY={'0-3 lakhs'=>0,'3-6 lakhs'=>1, '6-10 lakhs'=>2, '10-15 lakhs'=>3, "15-30 lakhs"=>4, "30-50 lakhs"=>5}.freeze

    belongs_to :job_category, class_name: "BxBlockJobs::JobCategory"
    has_many :account_jobs, class_name:"BxBlockJobs::AccountJob"
    has_and_belongs_to_many :accounts, class_name:"AccountBlock::Account"
    has_many :company_job_positions, class_name: "BxBlockJobs::CompanyJobPosition", join_table:"company_job_positions", dependent: :destroy
    has_many :companies, class_name:"BxBlockCompany::Company", through: :company_job_positions
    has_many :job_places, dependent: :destroy
    has_many :job_locations, through: :job_places
    belongs_to :sub_category, class_name:"BxBlockCategories::SubCategory", optional: true
    validates :name, :description, :job_type, :experience, :heading,  presence: true
    has_many :banners, class_name: "BxBlockContentmanagement::Banner", as: :bannerable, dependent: :destroy
    has_many :bookmarks, class_name: "BxBlockContentmanagement::Bookmark", as: :bookmarkable, dependent: :destroy
    has_many :account_bookmarks, class_name: "AccountBlock::Account", through: :bookmarks, source: :account
    acts_as_taggable_on :tags
    scope :trending_jobs, -> { where(trending: true) }
    scope :popular_jobs, -> { where(popular: true) }

    def name
      heading
    end

    rails_admin do
      configure :contentable do
        label 'Headline'
      end
      field :heading
      field :name
      field :description
      field :requirement
      field :job_type
      field :popular
      field :trending
      field :sub_category
      field :job_category
      field :experience
      field :companies
    end

  end
end
