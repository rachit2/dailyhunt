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
  class SocialAccountSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :first_name,
      :last_name,
      :full_phone_number,
      :country_code,
      :phone_number,
      :email,
      :activated,
    ]

    attribute :last_name do |object|
      nil
    end
    
  end
end
