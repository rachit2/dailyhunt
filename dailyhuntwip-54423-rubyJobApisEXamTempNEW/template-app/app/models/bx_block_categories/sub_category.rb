# == Schema Information
#
# Table name: sub_categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#
module BxBlockCategories
  class SubCategory < BxBlockCategories::ApplicationRecord
    self.table_name = :sub_categories

    has_and_belongs_to_many :categories, join_table: :categories_sub_categories, dependent: :destroy, :before_add => :validates_categories
    belongs_to :parent, class_name: "BxBlockCategories::SubCategory", optional: true
    has_many :sub_categories, class_name: "BxBlockCategories::SubCategory", foreign_key: :parent_id, dependent: :destroy
    has_many :user_sub_categories, class_name: "BxBlockCategories::UserSubCategory", join_table: "user_sub_categoeries", dependent: :destroy
    has_many :accounts, class_name: "AccountBlock::Account", through: :user_sub_categories, join_table: "user_sub_categoeries"
    has_many :contents, class_name: "BxBlockContentmanagement::Content", dependent: :destroy
    has_and_belongs_to_many :partners, class_name: 'BxBlockRolesPermissions::Partner', join_table: :partners_sub_categories, dependent: :destroy
    has_many :jobs, class_name:"BxBlockJobs::Job"
    has_many :colleges, class_name:"BxBlockProfile::College"

    validates :name, uniqueness: true, presence: true
    validate :check_parent_categories

    rails_admin do
      list do
        field :id
        field :name
        field :categories
        field :sub_categories
        field :parent
        field :created_at do
          label 'Created'
        end
        field :updated_at do
          label 'Updated'
        end
      end

      show do
        field :id
        field :name
        field :categories
        field :sub_categories
        field :parent
        field :created_at do
          label 'Created'
        end
        field :updated_at do
          label 'Updated'
        end
      end

      edit do
        field :name do
          label 'Sub Category Name'
        end
        field :rank
        field :colleges
        field :jobs
        field :parent do
          read_only do
            !bindings[:object].new_record?
          end
          help "You can only add parent at the time of creation only, It will not be editable after record is saved"
        end
        field :categories do
          read_only do
            !bindings[:object].new_record?
          end
          help "You can only add categories at the time of creation only, It will not be editable after record is saved"
        end
      end
    end

    private

    def check_parent_categories
      if categories.blank? && parent.blank?
        errors.add(:base, "Please select categories or a parent.")
      end
    end

    def validates_categories(category)
      errors.add(:category_ids, "Duplicate category #{category.name}") and throw(:abort) if self.categories.include? category
    end

  end
end
