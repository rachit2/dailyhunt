# == Schema Information
#
# Table name: subjects
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockProfile
  class SubjectSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :name,
      :rank
    ]

  end
end
