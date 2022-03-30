# == Schema Information
#
# Table name: partners
#
#  id                  :bigint           not null, primary key
#  account_name        :string
#  account_number      :bigint
#  address             :text
#  bank_ifsc           :string
#  bank_name           :string
#  created_by_admin    :boolean          default(TRUE)
#  includes_gst        :boolean
#  name                :string
#  partner_margins_per :float
#  partner_type        :integer
#  partnership_type    :integer
#  spoc_contact        :string
#  spoc_name           :string
#  status              :integer
#  tax_margins         :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  admin_user_id       :bigint
#
# Indexes
#
#  index_partners_on_admin_user_id  (admin_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_user_id => admin_users.id)
#
module BxBlockRolesPermissions
  class Partner < ApplicationRecord
    self.table_name = :partners

    validates_presence_of :status, :name, :spoc_name, :address, :categories, :sub_categories, :content_types
    validates_presence_of :partner_type, :partnership_type, :partner_margins_per, :tax_margins, if: :created_by_admin?

    validate :validate_status_not_declined, on: :create
    validates :spoc_contact,   presence: true,
              numericality: {message: 'Please enter a valid phone number'}

    validates_length_of :spoc_contact, minimum: 7, maximum: 15       

    has_one :logo, as: :attached_item, class_name: "Image", dependent: :destroy
    belongs_to :admin_user, class_name: 'BxBlockAdmin::AdminUser',inverse_of: :partner
    has_and_belongs_to_many :categories, class_name: 'BxBlockCategories::Category', join_table: :categories_partners, dependent: :destroy
    has_and_belongs_to_many :sub_categories, class_name: 'BxBlockCategories::SubCategory', join_table: :partners_sub_categories, dependent: :destroy
    has_and_belongs_to_many :content_types, class_name: 'BxBlockContentmanagement::ContentType', join_table: :content_types_partners, dependent: :destroy
    has_one :signed_agreement, as: :attached_item, class_name: "Pdf", dependent: :destroy, inverse_of: :attached_item
    accepts_nested_attributes_for :signed_agreement, allow_destroy: true
    accepts_nested_attributes_for :logo, allow_destroy: true


    enum status: ["pending", "approved", "decline"]
    enum partner_type: ["free", "paid"]
    enum partnership_type: ["strategic", "general"]

    after_initialize :set_defaults
    before_update :statuses_changes, if: :will_save_change_to_status?
    before_create :statuses_changes
    after_create :send_email_to_l1_l2

    def logo_url
      logo.image_url if logo.present?
    end

    rails_admin do
      edit do
        field :name
        field :logo do
          partial "partner_logo"
        end
        field :spoc_name
        field :spoc_contact
        field :address
        field :partner_type do
          help do
            "Required" if bindings[:object].created_by_admin?
          end
        end
        field :partnership_type do
          help do
            "Required" if bindings[:object].created_by_admin?
          end
        end
        field :partner_margins_per do
          label 'Partner margins(%)'
          help do
            "Required" if bindings[:object].created_by_admin?
          end
        end
        field :partner_type do
          help do
            "Required" if bindings[:object].created_by_admin?
          end
        end
        field :includes_gst
        field :tax_margins do
          help do
            "Required" if bindings[:object].created_by_admin?
          end
        end
        field :status
        field :category_ids do
          label 'Category'
          help 'Required'
          partial "category_select"
        end
        field :sub_category_ids do
          label 'Sub category'
          help 'Required'
          partial "sub_category_select"
        end
        field :content_type_ids do
          label 'Content type'
          help 'Required'
          partial "content_type_select"
        end
        field :signed_agreement do
          partial "partner_signed_agreement"
        end 
        field :bank_ifsc
        field :account_number
        field :account_name
        field :bank_name
      end

      show do
        field :name
        field :spoc_name
        field :spoc_contact
        field :address
        field :includes_gst
        field :status
        field :category_ids
        field :sub_category_ids
        field :content_type_ids
        field :signed_agreement do
          pretty_value do
            label 'Signed Agreement'
            if bindings[:object].signed_agreement.pdf.present?
              bindings[:view].render partial: 'pdf_preview', locals: {files: [bindings[:object].signed_agreement]}
            end
          end
        end
        field :bank_ifsc
        field :account_number
        field :account_name
        field :bank_name
      end

      configure :created_by_admin do
        visible false
      end
    end

    private

    def statuses_changes
      if approved?
        PartnerMailer.welcome_email(admin_user_id, name).deliver_later
      elsif decline?
        PartnerMailer.decline_email(admin_user.email).deliver_later
        admin_user.destroy
      end
    end

    def validate_status_not_declined
      errors.add(:status, "can not be declined while creating") if decline?
    end

    def send_email_to_l1_l2
      unless created_by_admin?
        ll_or_l2_user_emails = BxBlockAdmin::AdminUser.l1_and_l2_user.collect(&:email)
        ll_or_l2_user_emails.each do |l1_and_l2_user_email|
          PartnerMailer.send_email_l1_and_l2(self.id, l1_and_l2_user_email).deliver_later
        end
      end
    end

    def set_defaults
      self.status ||= created_by_admin? ? "approved" : "pending"
    end
  end
end
