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
module BxBlockExperts
  class CareerExpert < ApplicationRecord
    self.table_name=:career_experts
    mount_uploader :image, ImageUploader
    has_many :ratings, as: :reviewable, class_name: 'BxBlockContentmanagement::Rating', dependent: :destroy
    validates :name, :description, :designation, :status, :price,  presence: true
    has_many :articles, class_name:"BxBlockExperts::Article", dependent: :destroy
    has_many :bookmarks, class_name: "BxBlockContentmanagement::Bookmark", as: :bookmarkable, dependent: :destroy
    has_many :account_experts, class_name:"BxBlockExperts::AccountExpert", dependent: :destroy
    has_many :content_videos, class_name:"BxBlockContentmanagement::ContentVideo", dependent: :destroy
    has_many :content_texts, class_name:"BxBlockContentmanagement::ContentText", dependent: :destroy
    has_many :banners, class_name: "BxBlockContentmanagement::Banner", as: :bannerable, dependent: :destroy
    has_and_belongs_to_many :exams, class_name:"BxBlockContentmanagement::Exam", dependent: :destroy

    def booked_experts
      account_experts.where(mode:"Book")
    end

    def followed_experts
      account_experts.where(mode:"Follow")
    end

    def join_content_texts
      content_texts&.joins(contentable: :content_type)
    end

    def blog_content
      join_content_texts&.where(content_types:{identifier:BxBlockContentmanagement::ContentType.identifiers["blog"]})
    end

    def popular_blog_content
      blog_content.where(contents:{is_popular:true})
    end

    def popular_article_content
      article_content.where(contents:{is_popular:true})
    end

    def featured_blog_content
      blog_content.where(contents:{is_featured:true})
    end

    def featured_article_content
      article_content.where(contents:{is_featured:true})
    end

    def popular_video_content
      content_videos.joins(:contentable).where(contents:{is_popular:true})
    end

    def featured_video_content
      content_videos.joins(:contentable).where(contents:{is_featured:true})
    end

    def article_content
      join_content_texts&.where(content_types:{identifier:BxBlockContentmanagement::ContentType.identifiers["news_article"]})
    end

    acts_as_taggable_on :tags

    rails_admin do
      edit do
        field :heading
        field :exams
        field :name
        field :description
        field :designation
        field :status
        field :price
        field :image
        field :rating
        field :tags do
          searchable [{ ActsAsTaggableOn::Tag => :name}]
          label "Tags"
          pretty_value do
            bindings[:object].tag_list
          end
        end
      end
    end
  end
end
