# == Schema Information
#
# Table name: contents
#
#  id               :bigint           not null, primary key
#  archived         :boolean          default(FALSE)
#  contentable_type :string
#  crm_type         :integer
#  detail_url       :string
#  feature_article  :boolean
#  feature_video    :boolean
#  feedback         :string
#  is_featured      :boolean
#  is_popular       :boolean
#  is_trending      :boolean
#  publish_date     :datetime
#  review_status    :integer
#  searchable_text  :string
#  status           :integer
#  view_count       :bigint           default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  admin_user_id    :integer
#  author_id        :bigint
#  career_expert_id :integer
#  category_id      :integer
#  content_type_id  :integer
#  contentable_id   :bigint
#  crm_id           :integer
#  language_id      :integer
#  sub_category_id  :integer
#
# Indexes
#
#  index_contents_on_author_id                            (author_id)
#  index_contents_on_contentable_type_and_contentable_id  (contentable_type,contentable_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => authors.id)
#
module BxBlockContentmanagement
  class Content < ApplicationRecord
    self.table_name = :contents
    #constant
    MAX_TAG_CHARACTERS = 35
    SEARCHABLE_FIELDS = [
      :name,
      :description,
      :searchable_text,
      :tags,
      :category_name,
      :sub_category_name,
      :language_name,
      :content_type_name,
      :exam_heading
    ].freeze

    # belongs_to
    belongs_to :category, class_name: 'BxBlockCategories::Category', foreign_key: 'category_id'
    belongs_to :sub_category, class_name: 'BxBlockCategories::SubCategory', foreign_key: 'sub_category_id'
    belongs_to :content_type, class_name: 'BxBlockContentmanagement::ContentType', foreign_key: 'content_type_id'
    belongs_to :language, class_name: 'BxBlockLanguageoptions::Language', foreign_key: 'language_id'
    belongs_to :contentable, polymorphic: true, inverse_of: :contentable, autosave: true, dependent: :destroy
    belongs_to :exam, class_name:"BxBlockContentmanagement::Exam", optional: true, foreign_key: "exam_id"
    belongs_to :admin_user, class_name: 'BxBlockAdmin::AdminUser', optional: true
    belongs_to :author, class_name: 'BxBlockContentmanagement::Author', optional: true
    has_many :bookmarks, class_name: "BxBlockContentmanagement::Bookmark", as: :bookmarkable, dependent: :destroy
    has_many :account_bookmarks, class_name: "AccountBlock::Account", through: :bookmarks, source: :account

    validates :author_id, presence: true, if: -> { self.content_type&.blog? }
    validates :publish_date, presence: true, if: ->{ self.publish? }
    validates :status, presence: true
    validate :validate_publish_date, on: :update
    validate  :validate_status, on: :update
    validate  :validate_to_change_status, on: :update
    validate  :validate_content_type, on: :update
    validate :validate_approve_status, on: :update
    validate :max_tag_char_length
    validates :feedback, presence: true, if: -> { self.rejected? }
    before_save :send_email_to_l2, if: :will_save_change_to_review_status?
    before_save :send_email_to_l1, if: :will_save_change_to_review_status?

    scope :operations_l1_content, -> { where(review_status: ["pending", "rejected", "submit_for_review"]) }
    scope :submit_for_review_l1_content, -> { where(review_status: ["submit_for_review"]) }

    attr_accessor :current_user_id

    after_initialize :set_defaults
    before_save :set_defaults_review_status

    accepts_nested_attributes_for :contentable

    scope :non_archived, -> { where(archived: false) }
    scope :archived, -> { where(archived: true) }

    searchkick text_middle: SEARCHABLE_FIELDS

    acts_as_taggable_on :tags

    enum status: ["draft", "publish", "disable"]
    enum crm_type: ["careerindia"]

    enum review_status: ["pending", "submit_for_review", "approve", "rejected"]

    scope :published, -> {publish.where("publish_date < ?", DateTime.current)}
    scope :blogs_content, -> { joins(:content_type).where(content_types: {identifier: 'blog'}) }
    scope :filter_content, ->(categories, sub_categories, content_types) { where(category: categories, sub_category: sub_categories, content_type: content_types) }
    scope :partner_content, ->(admin_user_id) { where(admin_user_id: admin_user_id)}
    scope :in_review, -> { where(review_status: "submit_for_review")}

    def contentable_attributes=(attributes)
      self.contentable_type = content_type&.type_class
      if self.contentable_type
        some_contentable = self.contentable_type.constantize.find_or_initialize_by(id: self.contentable_id)
        some_contentable.attributes = attributes
        self.contentable = some_contentable
      end
    end

    def name
      contentable&.name
    end

    def description
      contentable&.description
    end

    def image
      contentable&.image_url
    end

    def video
      contentable&.video_url
    end

    def audio
      contentable&.audio_url
    end

    def study_material
      contentable&.study_material_url
    end

    rails_admin do
      configure :contentable do
        label 'Headline'
      end

      list do
        scopes do
          [:non_archived, :archived, :in_review, :rejected]
        end
      end
      field :category
      field :sub_category
      field :exam
      field :searchable_text
      field :language
      field :content_type
      field :contentable
      # field :feature_article
      # field :feature_video
      field :is_featured
      field :is_trending
      field :is_popular
      field :publish_date
      field :status
      field :admin_user
      field :review_status
      field :feedback
      field :author
      field :archived
      field :tags do
        searchable [{ ActsAsTaggableOn::Tag => :name}]
        label "Tags"
        pretty_value do
          bindings[:object].tag_list
        end
      end
      field :created_at
      field :updated_at
    end

    def search_data
      {
        name: self.name.to_s.downcase,
        description: ActionView::Base.full_sanitizer.sanitize(self.description.to_s).to_s.gsub(/[^\w ]/, '').downcase.truncate(300),
        searchable_text: self&.searchable_text.to_s&.downcase,
        tags: self.tags&.map(&:name)&.join(" ").to_s&.downcase,
        category_name: self.category&.name.to_s&.downcase,
        exam_heading: self.exam&.heading.to_s&.downcase,
        sub_category_name: self.sub_category&.name.to_s&.downcase,
        language_name: self.language&.name.to_s&.downcase,
        content_type_name: self.content_type&.name.to_s&.downcase,
      }
    end

    private

      def max_tag_char_length
        self.tag_list.each do |tag|
          errors[:tag] << "#{tag} must be shorter than #{MAX_TAG_CHARACTERS} characters maximum" if tag.length > MAX_TAG_CHARACTERS
        end
      end

      def validate_status
        if self.draft? && will_save_change_to_status?
          errors.add(:status, "can't be change to draft.")
        end
      end

      def validate_to_change_status
        if status_in_database == 'disable' && !super_admin_or_l2_user?(current_user_id) && will_save_change_to_status?
          errors.add(:status, "can't be change once disable only super admin and l2 user can change.")
        end
      end

      def validate_content_type
        errors.add(:content_type_id, "can't be updated") if will_save_change_to_content_type_id?
      end

      def validate_publish_date
        if status_in_database == 'publish' && will_save_change_to_publish_date? && publish_date_in_database.present? && publish_date_in_database <= DateTime.current
          errors.add(:publish_date, "can't be changed after published.")
        end
      end

      def set_defaults
        self.status ||= "draft"
      end

      def validate_approve_status
        if will_save_change_to_status? && self.publish? && !self.approve?
          errors.add(:status, "can't be published if content was not approved.")
        end
      end

      def send_email_to_l2
        if self.admin_user.present? and self.admin_user.operations_l1? and self.submit_for_review?
          l2_user_emails = BxBlockAdmin::AdminUser.operation_l2_and_admin.collect(&:email)
          l2_user_emails.each do |l2_user_email|
            BxBlockContentmanagement::ContentMailer.send_email_l2(self.admin_user_id, l2_user_email, self.id).deliver_later
          end
        end
      end

      def send_email_to_l1
        check_l2_user = super_admin_or_l2_user?(current_user_id)
        if self.admin_user.present? and self.admin_user.operations_l1? and check_l2_user and (self.approve? || self.rejected?)
          l1_user_email = self.admin_user.email
          ContentMailer.send_email_l1(current_user_id, l1_user_email, self.review_status, self.name).deliver_later
        end
      end

      def set_defaults_review_status
        if self.admin_user&.operations_l1?
          self.review_status ||= "pending"
        else
          self.review_status ||= "approve"
        end
      end

      def super_admin_or_l2_user?(user_id)
        user = BxBlockAdmin::AdminUser.find_by(id: user_id)
        user&.operations_l2? || user&.super_admin?
      end
  end
end
