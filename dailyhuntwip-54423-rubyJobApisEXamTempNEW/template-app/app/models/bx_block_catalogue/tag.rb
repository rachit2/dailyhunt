# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockCatalogue
  class Tag < BxBlockCatalogue::ApplicationRecord
    self.table_name = :tags

    has_and_belongs_to_many :catalogue, join_table: :catalogues_tags
  end
end
