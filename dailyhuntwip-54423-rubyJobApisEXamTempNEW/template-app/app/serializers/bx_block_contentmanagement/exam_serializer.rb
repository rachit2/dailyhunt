# == Schema Information
#
# Table name: exams
#
#  id              :bigint           not null, primary key
#  description     :text
#  from            :date
#  heading         :string
#  thumbnail       :string
#  to              :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  category_id     :bigint
#  sub_category_id :bigint
#
# Indexes
#
#  index_exams_on_category_id      (category_id)
#  index_exams_on_sub_category_id  (sub_category_id)
#

module BxBlockContentmanagement
  class ExamSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :description, :thumbnail, :exam_updates, :exam_sections, :from,:to, :content_videos, :created_at, :updated_at, :popular, :content_provider, :tags, :category, :sub_category,  :courses, :assessments, :career_experts

    attribute :assessments do |object,params|
      BxBlockContentmanagement::AssessmentSerializer.new(object.assessments)&.serializable_hash[:data]
    end

    attribute :content_videos do |object, params|
      contents = BxBlockContentmanagement::Content.where(contentable_id:object.content_videos&.pluck(:id))
      # BxBlockContentmanagement::ContentVideoSerializer.new(object.content_videos)&.serializable_hash[:data]
      BxBlockContentmanagement::ContentSerializer.new(contents)&.serializable_hash[:data]
    end

    attribute :thumbnail do |object|
      object.thumbnail_url if object.thumbnail.present?
    end

    attribute :from do |object|
      object.start_date&.strftime("%B %d, %Y")
    end

    attribute :to do |object|
      object.end_date&.strftime("%B %d, %Y")
    end

    attributes :exam_updates do |object|
      ExamUpdateSerializer.new(object.exam_updates)
    end

    attributes :exam_sections do |object|
      ExamSectionSerializer.new(object.exam_sections)
    end
  end
end
