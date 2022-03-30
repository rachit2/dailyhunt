# == Schema Information
#
# Table name: catalogues_tags
#
#  id           :bigint           not null, primary key
#  catalogue_id :bigint           not null
#  tag_id       :bigint           not null
#
# Indexes
#
#  index_catalogues_tags_on_catalogue_id  (catalogue_id)
#  index_catalogues_tags_on_tag_id        (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (catalogue_id => catalogues.id)
#  fk_rails_...  (tag_id => tags.id)
#
module BxBlockCatalogue
  class CataloguesTag < BxBlockCatalogue::ApplicationRecord
    self.table_name = :catalogues_tags

    belongs_to :catalogue
    belongs_to :tag
  end
end
