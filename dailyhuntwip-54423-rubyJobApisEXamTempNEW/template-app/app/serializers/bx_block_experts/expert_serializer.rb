# == Schema Information
#
# Table name: employment_details
#
#  id                      :bigint           not null, primary key
#  last_employer           :string
#  designation             :string
#  rank                    :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  domain_work_function_id :bigint
#
module BxBlockExperts
  class ExpertSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :name,
      :description,
      :designation,
      :status,
      :image,
      :price,
      :tags,
      :bookmark,
      :account_experts,
      :content_texts,
      :content_blogs,
      :content_articles,
      :content_videos,
      :discussions,
      :booked,
      :followed,
      :exams
    ]

    attribute :booked do |object, params|
      object.booked_experts.where(account_id:params[:current_user_id]).present?
    end

    attribute :discussions do |object, params|
      questions = BxBlockCommunityforum::Question.all
      questions = questions.popular_questions if params[:is_popular]
      BxBlockCommunityforum::QuestionSerializer.new(questions)&.serializable_hash[:data]
    end

    attribute :followed do |object, params|
      object.followed_experts.where(account_id:params[:current_user_id]).present?
    end

    attribute :content_blogs do |object, params|
      contents = object.blog_content
      contents = object.popular_blog_content if params[:is_popular]
      contents = object.featured_blog_content if params[:is_featured]
      BxBlockContentmanagement::ContentTextSerializer.new(contents, params:{current_user_id:params[:current_user_id]})&.serializable_hash[:data]
    end

    attribute :content_articles do |object, params|
      contents = object.article_content
      contents = object.popular_article_content if params[:is_popular]
      contents = object.featured_article_content if params[:is_featured]
      BxBlockContentmanagement::ContentTextSerializer.new(contents,params:{current_user_id:params[:current_user_id]})&.serializable_hash[:data]
    end

    attribute :content_videos do |object, params|
      contents = object.content_videos
      contents = object.popular_video_content if params[:is_popular]
      contents = object.featured_video_content if params[:is_featured]

      BxBlockContentmanagement::ContentVideoSerializer.new(contents,params:{current_user_id:params[:current_user_id]})&.serializable_hash[:data]
    end

    attribute :content_texts do |object, params|
      BxBlockContentmanagement::ContentTextSerializer.new(object.content_texts,params:{current_user_id:params[:current_user_id]})&.serializable_hash[:data]
    end

    attribute :bookmark do |object, params|
      params && params[:current_user_id] && current_user_bookmark(object, params[:current_user_id]) ? true : false
    end

    attribute :image do |object|
      object.image_url if object.image.present?
    end

    class << self
      private
      def current_user_bookmark(record, current_user_id)
        record.bookmarks.where(account_id: current_user_id).present?
      end

    end

  end
end
