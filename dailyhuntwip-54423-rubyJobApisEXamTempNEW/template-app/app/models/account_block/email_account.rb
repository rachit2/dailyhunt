# == Schema Information
#
# Table name: accounts
#
#  id                :bigint           not null, primary key
#  activated         :boolean          default(FALSE), not null
#  city              :string
#  country_code      :integer
#  dob               :date
#  email             :string
#  email_verified    :boolean
#  first_name        :string
#  full_phone_number :string
#  gender            :integer
#  last_name         :string
#  last_visit_at     :datetime
#  password_digest   :string
#  phone_number      :bigint
#  phone_verified    :boolean
#  type              :string
#  user_name         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  app_language_id   :integer
#  desktop_device_id :string
#  device_id         :string
#  role_id           :integer
#  unique_auth_id    :text
#
module AccountBlock
  class EmailAccount < Account
    include Wisper::Publisher
    validates :email, presence: true
  end
end
