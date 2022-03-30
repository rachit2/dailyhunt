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
  class ApplicationConfigSerializer < BuilderBase::BaseSerializer
    attributes :mime_type, :home_page_description, :created_at, :updated_at

    attributes :login_background_file do |object|
      object.login_background_file.login_background_file_url if object.login_background_file.present?
    end
  end
end
