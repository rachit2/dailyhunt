# == Schema Information
#
# Table name: application_messages
#
#  id                     :bigint           not null, primary key
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  application_message_id :bigint           not null
#  message                :text             not null
#
module BxBlockLanguageoptions
  class ApplicationMessageSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :created_at, :updated_at

    attribute :translations do |object|
      TranslationSerializer.new(object.translations)
    end

  end
end
