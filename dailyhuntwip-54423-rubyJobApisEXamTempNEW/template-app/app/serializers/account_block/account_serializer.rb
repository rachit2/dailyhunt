# == Schema Information
#
# Table name: accounts
#
#  id                :bigint           not null, primary key
#  first_name        :string
#  last_name         :string
#  full_phone_number :string
#  country_code      :integer
#  phone_number      :bigint
#  email             :string
#  activated         :boolean          default(FALSE), not null
#  device_id         :string
#  unique_auth_id    :text
#  password_digest   :string
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_name         :string
#  role_id           :integer
#  city              :string
#  app_language_id   :integer
#  last_visit_at     :datetime
#  desktop_device_id :string
#  dob               :date
#  gender            :integer
#
module AccountBlock
  class AccountSerializer < BuilderBase::BaseSerializer
    attributes *[
      :activated,
      :country_code,
      :email,
      :first_name,
      :full_phone_number,
      :last_name,
      :phone_number,
      :type,
      :city,
      :dob,
      :gender,
      :created_at,
      :updated_at,
      :device_id,
      :unique_auth_id,
      :languages,
      :app_language,
      :categories,
      :desktop_device_id,
      :profile,
      :email_verified,
      :phone_verified
    ]

    attribute :country_code do |object|
      country_code_for object
    end

    attributes :categories do |object|
      BxBlockCategories::CategorySerializer.new(object.categories.order(:rank), serialization_options(object))
    end

    attributes :profile do |object|
      BxBlockProfile::ProfileSerializer.new(object.profile) if object.profile.present?
    end

    attribute :phone_number do |object|
      phone_number_for object
    end

    attributes :user_pic do |object|
      object.image.image_url if object.image.present?
    end

    class << self
      private
      def country_code_for(object)
        return nil unless Phonelib.valid?(object.full_phone_number)
        Phonelib.parse(object.full_phone_number).country_code
      end

      def phone_number_for(object)
        return nil unless Phonelib.valid?(object.full_phone_number)
        Phonelib.parse(object.full_phone_number).raw_national
      end

      def serialization_options(object)
        options = {}
        options[:params] = { selected_sub_categories: object.sub_categories }
        options
      end
    end
  end
end
