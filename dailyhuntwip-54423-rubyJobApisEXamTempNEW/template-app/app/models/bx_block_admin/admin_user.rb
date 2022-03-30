# == Schema Information
#
# Table name: admin_users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email                 (email) UNIQUE
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#
module BxBlockAdmin
  class AdminUser < ::ApplicationRecord
    EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

    validates :email, :role, presence: true
    validates :email, format: { with: EMAIL_REGEXP }, if: ->{ email.present? }
    validates_presence_of :partner, if: :partner?
    validates_absence_of :partner, unless: :partner?

    has_one :admin_user_role, class_name: 'BxBlockAdmin::AdminUserRole', dependent: :destroy
    has_one :role, through: :admin_user_role, class_name: 'BxBlockRolesPermissions::Role'
    has_one :partner, class_name: 'BxBlockRolesPermissions::Partner', dependent: :destroy, inverse_of: :admin_user
    has_many :follows, class_name: "BxBlockContentmanagement::Follow", dependent: :destroy, foreign_key: :content_provider_id
    has_many :account_follows, class_name: "AccountBlock::Account", through: :follows, source: :account
    has_many :courses, class_name: "BxBlockContentmanagement::Course", foreign_key: :content_provider_id, dependent: :destroy
    has_many :quizzes, class_name: "BxBlockContentmanagement::Quiz", foreign_key: :content_provider_id, dependent: :destroy
    has_many :assessments, class_name: "BxBlockContentmanagement::Assessment", foreign_key: :content_provider_id, dependent: :destroy
    has_many :exams, class_name: "BxBlockContentmanagement::Exam", foreign_key: :content_provider_id, dependent: :destroy

    accepts_nested_attributes_for :partner, allow_destroy: true
    before_validation :create_password, if: ->{ new_record? && password.blank? }

    attr_accessor :template


    devise :database_authenticatable, :rememberable, :validatable

    scope :operation_l2_user, -> { joins(:role).where(roles: {name: ['partner', 'operations_l1']}) }
    scope :partner_user, -> { joins(:role).where(roles: {name: 'partner'}) }
    scope :l1_and_l2_user, -> { joins(:role).where(roles: {name: ['operations_l2', 'operations_l1']}) }
    scope :operation_l2_and_admin, -> { joins(:role).where(roles: {name: ['operations_l2', 'super_admin']}) }
    scope :filter_content_provider, ->(category_id, sub_category_id, content_type_id) { joins(partner: [:categories, :sub_categories, :content_types]).where(partners: {categories: { id: category_id }, sub_categories: { id: sub_category_id }, content_types: { id: content_type_id }}) }

    def name
      email
    end

    def role_id
      self.role.try :id
    end

    def role_id=(id)
      self.role = BxBlockRolesPermissions::Role.find_by_id(id)
    end

    BxBlockRolesPermissions::Role.names.keys.each do |role|
      define_method("#{role}?") do
        self.role&.send("#{role}?")
      end
    end

    def partner_id
      self.partner.try :id
    end

    def partner_id=(id)
      self.partner = BxBlockRolesPermissions::Partner.find_by_id(id)
    end

    def set_random_password
      self.password = SecureRandom.hex(8)
    end

    def partner_name
      partner&.name
    end

    def logo
      partner&.logo_url
    end

    rails_admin do
      configure :password do
        required do
          bindings[:object].new_record?
        end
        help do
          bindings[:object].new_record? ?  "Required. Length of 6-128." : "Optional. Length of 6-128."
        end
      end

      configure :password_confirmation do
        required do
          bindings[:object].new_record?
        end
        help do
          bindings[:object].new_record? ?  "Required." : "Optional."
        end
      end

      configure :partner do
        help "Required"
      end

      list do
        field :id
        field :email
        field :role do
          searchable [:name]
        end
        field :created_at do
          filterable false
        end
        field :partner
         #link_to "L1 user Template",create_partner_url, class: "btn btn-primary ", id: "li_user_reg"
      end

      edit do
        field :email
        field :role
        field :password do
          visible do
            !(bindings[:object].partner? && !(bindings[:object].partner.status_in_database == "approved")) rescue nil
          end
        end
        field :password_confirmation do
          visible do
            !(bindings[:object].partner? && !(bindings[:object].partner.status_in_database == "approved")) rescue nil
          end
        end
        field :partner
        field :template do
          view_helper :hidden_field

          # I added these next two lines to solve this
          label :hidden => true
          help ""

          partial :template_description
          def value
            bindings[:view]._current_user.id
          end
        end
      end
      show do
        field :id
        field :email
        field :role
        field :partner
        field :password
        field :password_confirmation
        field :created_at
        field :updated_at
      end
    end

  private

  def create_password
    set_random_password
  end

  end
end
