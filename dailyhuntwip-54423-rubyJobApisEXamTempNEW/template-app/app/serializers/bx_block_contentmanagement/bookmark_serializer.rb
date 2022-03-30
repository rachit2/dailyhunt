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
  class BookmarkSerializer < BuilderBase::BaseSerializer
    attributes :id, :account, :content, :created_at, :updated_at

    attribute :content do |object|
      object.bookmarkable
    end
  end
end
