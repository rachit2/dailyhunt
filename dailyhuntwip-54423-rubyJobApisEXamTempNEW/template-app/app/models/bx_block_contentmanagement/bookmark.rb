# == Schema Information
#
# Table name: bookmarks
#
#  id                :bigint           not null, primary key
#  bookmarkable_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint           not null
#  bookmarkable_id   :bigint
#
# Indexes
#
#  index_bookmarks_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
module BxBlockContentmanagement
	class Bookmark < ApplicationRecord
		self.table_name = :bookmarks
    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :bookmarkable, polymorphic: true

    TYPE_MAPPINGS = {
      "content" => BxBlockContentmanagement::Content.name,
      "course" => BxBlockContentmanagement::Course.name,
      "job" => BxBlockJobs::Job.name,
      "expert" => BxBlockExperts::CareerExpert.name,
      "company" => BxBlockCompany::Company.name,
      "article"=>BxBlockContentmanagement::ContentText.name,
      "blog" =>BxBlockContentmanagement::ContentText.name,
      "video"=>BxBlockContentmanagement::ContentVideo.name
    }.freeze

    validates_presence_of :account_id, :bookmarkable_id, :bookmarkable_type
    validates :account_id, uniqueness: { scope: [:bookmarkable_id, :bookmarkable_type], message: "content with this account is already taken"}
	end
end
