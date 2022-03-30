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
  class LanguageSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :language_code, :created_at, :updated_at

    attribute :count do |object, params|
      params[:count][object.id] if params && params[:count]
    end
  end 
end
