# == Schema Information
#
# Table name: categories
#
#  id                  :bigint           not null, primary key
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  admin_user_id       :integer
#  rank                :integer
#  light_icon          :string
#  light_icon_active   :string
#  light_icon_inactive :string
#  dark_icon           :string
#  dark_icon_active    :string
#  dark_icon_inactive  :string
#  identifier          :integer
#
module BxBlockCategories
  class Category < BxBlockCategories::ApplicationRecord
    self.table_name = :categories

    mount_uploader :light_icon, ImageUploader
    mount_uploader :light_icon_active, ImageUploader
    mount_uploader :light_icon_inactive, ImageUploader
    mount_uploader :dark_icon, ImageUploader
    mount_uploader :dark_icon_active, ImageUploader
    mount_uploader :dark_icon_inactive, ImageUploader

    has_and_belongs_to_many :sub_categories,
                            join_table: :categories_sub_categories, dependent: :destroy

    has_many :contents, class_name: "BxBlockContentmanagement::Content", dependent: :destroy
    has_many :ctas, class_name: "BxBlockCategories::Cta", dependent: :nullify

    has_many :user_categories, class_name: "BxBlockCategories::UserCategory", join_table: "user_categoeries", dependent: :destroy
    has_many :accounts, class_name: "AccountBlock::Account", through: :user_categories, join_table: "user_categoeries"
    has_and_belongs_to_many :partners, class_name: 'BxBlockRolesPermissions::Partner', join_table: :categories_partners, dependent: :destroy
    belongs_to :admin_user, class_name: "BxBlockAdmin::AdminUser", optional: true
    has_many :colleges, through: :sub_categories
    has_many :articles, class_name:"BxBlockExperts::Article"
    validates :name, uniqueness: true, presence: true
    validates_uniqueness_of :identifier, allow_blank: true
    validates :light_icon, :light_icon_active, :light_icon_inactive, :dark_icon, :dark_icon_active, :dark_icon_inactive, presence: true

    enum identifier: ["k12", "higher_education", "govt_job", "competitive_exams", "upskilling"]

    rails_admin do
      list do
        field :id
        field :name
        field :sub_categories
        field :admin_user
        field :rank
        field :identifier
        field :created_at do
          label 'Created'
        end
        field :updated_at do
          label 'Updated'
        end
      end

      edit do
        field :name do
          label 'Category Name'
        end
        field :identifier
        field :light_icon, :carrierwave
        field :light_icon_active, :carrierwave
        field :light_icon_inactive, :carrierwave
        field :dark_icon, :carrierwave
        field :dark_icon_active, :carrierwave
        field :dark_icon_inactive, :carrierwave
        field :admin_user_id do
          # This hides the field label
          label false
          visible do
            bindings[:object].new_record?
          end
          # This hides the help field *yuk*
          help ""
          def value
            bindings[:view]._current_user.id
          end
          # This hides the field input
          view_helper do
            :hidden_field
          end
        end
        field :rank
      end

      show do
        field :id
        field :name
        field :identifier
        field :light_icon, :carrierwave
        field :light_icon_active, :carrierwave
        field :light_icon_inactive, :carrierwave
        field :dark_icon, :carrierwave
        field :dark_icon_active, :carrierwave
        field :dark_icon_inactive, :carrierwave
        field :sub_categories
        field :admin_user
        field :rank
        field :created_at do
          label 'Created'
        end
        field :updated_at do
          label 'Updated'
        end
      end
    end
  end
end
