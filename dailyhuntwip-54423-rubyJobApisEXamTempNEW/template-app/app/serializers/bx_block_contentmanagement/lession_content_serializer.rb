# == Schema Information
#
# Table name: lession_contents
#
#  id           :bigint           not null, primary key
#  content_type :integer
#  description  :text
#  duration     :string
#  file_content :string
#  heading      :string
#  is_free      :boolean          default(FALSE)
#  rank         :integer
#  thumbnail    :string
#  video        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lession_id   :bigint           not null
#
# Indexes
#
#  index_lession_contents_on_lession_id  (lession_id)
#
# Foreign Keys
#
#  fk_rails_...  (lession_id => lessions.id)
#
module BxBlockContentmanagement
  class LessionContentSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :description, :rank, :is_free, :is_purchased, :content_type, :duration, :thumbnail, :video, :file_content, :created_at, :updated_at
    attribute :is_purchased do |object, params|
      params[:paid]
    end
    attribute :thumbnail do |object, params|
      object.thumbnail_url if object.thumbnail.present?
    end
    attribute :video do |object, params|
      if object.is_free || params[:paid]
        object.video_url if object.video.present?
      end
    end
    attribute :file_content do |object, params|
      if object.is_free || params[:paid]
        object.file_content_url if object.file_content.present?
      end
    end
    attribute :is_lession_content_read do |object, params|
      params[:read_lessions_ids].include? object.id if params[:read_lessions_ids].present?
    end
  end
end
