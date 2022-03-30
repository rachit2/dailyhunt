# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :text
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockDashboard
  class FaqSerializer < BuilderBase::BaseSerializer
    attributes :id, :question, :answer, :created_at, :updated_at
  end
end
