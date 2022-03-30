# == Schema Information
#
# Table name: application_configs
#
#  id                    :bigint           not null, primary key
#  mime_type             :string
#  status                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  home_page_description :text
#
module BxBlockLogin
  class ApplicationConfig < ApplicationRecord
    include Configuration
    self.table_name = :application_configs

    has_one :login_background_file, as: :attached_item, class_name: "LoginBackgroundFile", dependent: :destroy, inverse_of: :attached_item
    accepts_nested_attributes_for :login_background_file, allow_destroy: true

    before_validation :check_mime_type
    validates_presence_of :login_background_file

    validates :home_page_description, length: {maximum: 400}

    class << self
      def config
        active.first
      end
    end

    def name
      id
    end

    rails_admin do
      edit do
        field :home_page_description
        field :status
        field :login_background_file do
          partial "login_background_file"
        end
      end

      list do
        field :id
        field :home_page_description
        field :status
        field :mime_type
        field :login_background_file do
          pretty_value do
            label 'Login Background'
            if bindings[:object].login_background_file.login_background_file.present?
              bindings[:view].render partial: 'login_background_preview', locals: {object: bindings[:object] }
            end
          end
        end
        field :created_at
        field :updated_at
      end

      show do
        field :home_page_description
        field :status
        field :mime_type
        field :login_background_file do
          pretty_value do
            label 'Login Background'
            if bindings[:object].login_background_file.login_background_file.present?
              bindings[:view].render partial: 'login_background_preview', locals: {object: bindings[:object] }
            end
          end
        end
      end
    end

    private

    def check_mime_type
      self.mime_type = Rack::Mime.mime_type(File.extname(self.login_background_file.login_background_file.path)) if self.login_background_file.present? and self.login_background_file.login_background_file.path.present?
    end
  end
end
