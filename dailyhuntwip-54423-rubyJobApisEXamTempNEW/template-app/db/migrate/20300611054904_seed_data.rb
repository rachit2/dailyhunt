class SeedData < ActiveRecord::Migration[6.0]
  def up
    BxBlockCategories::BuildCategories.call
    BxBlockLanguageoptions::BuildLanguages.call
    BxBlockContentmanagement::BuildContentType.call
    BxBlockContentmanagement::BuildRole.call
    BxBlockAdmin::CreateAdmin.call
  end
end
