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
  class ApplicationMessage < ApplicationRecord
    self.table_name = :application_messages

    translates :message, touch: true

    validates :name, presence: true, uniqueness: {case_sensitive: false}
    translation_class.validates :message, presence: { message: "EN translation message can't be blank" }, if: -> (trans) { trans.locale == :en }

    accepts_nested_attributes_for :translations, allow_destroy: true

    def self.translation_message(key)
      application_message = BxBlockLanguageoptions::ApplicationMessage.find_by(name: key)
      if application_message.present?
        return application_message.message if application_message.message.present?
        "Translation not present for key: #{key}, locale: #{Globalize.locale()}"
      else
        "Translation not present for key: #{key}"
      end
    end

    def self.set_message_for(key, locale, message)
      application_message = BxBlockLanguageoptions::ApplicationMessage.find_by(name: key)
      if application_message.present?
        application_message.update!(locale: locale, message: message)
      else
        raise "Translation not present for key: #{key}"
      end
    end

    rails_admin do
      list do
        field :id
        field :name
        field :message
        field :created_at
        field :updated_at
      end

      show do
        field :id
        field :name
        field :translations do
          pretty_value do
            translations = []
            bindings[:object].translations.each do |translation|
              translations << "#{translation.locale}: #{translation.message}"
            end
            translations.join("<br/>").html_safe
          end
        end
        field :created_at
        field :updated_at
      end
    end
  end
end
