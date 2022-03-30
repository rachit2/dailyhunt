# == Schema Information
#
# Table name: email_otps
#
#  id          :bigint           not null, primary key
#  email       :string
#  pin         :integer
#  activated   :boolean          default(FALSE), not null
#  valid_until :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module AccountBlock
  class EmailOtpSerializer < BuilderBase::BaseSerializer
    attributes :email, :activated, :created_at
    attributes :valid_until
  end
end
