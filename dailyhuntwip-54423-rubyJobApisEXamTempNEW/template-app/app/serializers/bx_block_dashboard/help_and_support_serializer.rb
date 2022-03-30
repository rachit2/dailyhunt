# == Schema Information
#
# Table name: help_and_supports
#
#  id         :bigint           not null, primary key
#  answer     :text
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockDashboard
  class HelpAndSupportSerializer < BuilderBase::BaseSerializer
    attributes :id, :question, :answer, :created_at, :updated_at
  end
end
