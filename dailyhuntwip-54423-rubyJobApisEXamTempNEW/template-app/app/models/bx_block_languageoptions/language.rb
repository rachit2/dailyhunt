# == Schema Information
#
# Table name: languages
#
#  id                  :bigint           not null, primary key
#  name                :string
#  language_code       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  is_content_language :boolean
#  is_app_language     :boolean
#
module BxBlockLanguageoptions
  class Language < ApplicationRecord
    self.table_name = :languages

    validates :name, :language_code, uniqueness: {case_sensitive: false}, presence: true

    scope :content_languages, -> { where("is_content_language is true") }
    scope :app_languages, -> { where("is_app_language is true") }

    has_many :contents_languages, class_name: "BxBlockLanguageoptions::ContentLanguage", join_table: "contents_languages", dependent: :destroy
    has_many :accounts, class_name: "AccountBlock::Account", through: :contents_languages, join_table: "contents_languages"
    has_many :contents, class_name: "BxBlockContentmanagement::Content", dependent: :destroy

    after_commit :update_available_locales

    rails_admin do
      list do
        field :id do
          filterable false
        end
        field :name
        field :language_code
        field :is_app_language
        field :is_content_language
        field :created_at do
          filterable false
        end
        field :updated_at do
          filterable false
        end
      end

      edit do
        field :name do
          label 'Language Name'
        end
        field :language_code do
          label 'Language Code'
        end
        field :is_app_language do
          label 'Is App Language'
        end
        field :is_content_language do
          label 'Is Content Language'
        end
      end

      show do
        field :id
        field :name
        field :language_code
        field :is_app_language
        field :is_content_language
        field :created_at
        field :updated_at
      end
    end

    private
    def update_available_locales
      BxBlockLanguageoptions::SetAvailableLocales.call
    end

  end
end
