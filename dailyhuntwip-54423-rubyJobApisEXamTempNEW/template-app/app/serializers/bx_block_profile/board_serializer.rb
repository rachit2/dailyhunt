# == Schema Information
#
# Table name: boards
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockProfile
  class BoardSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :name,
      :rank
    ]

  end
end
