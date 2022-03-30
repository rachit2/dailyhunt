# == Schema Information
#
# Table name: tests
#
#  id          :bigint           not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  headline    :string
#
module BxBlockContentmanagement
  class TestSerializer < BuilderBase::BaseSerializer
    attributes :id, :description, :created_at, :updated_at
  end
end
