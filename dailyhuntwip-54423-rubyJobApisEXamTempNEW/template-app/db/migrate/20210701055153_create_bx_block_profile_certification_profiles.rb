class CreateBxBlockProfileCertificationProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :certification_profiles do |t|
      t.references :certification, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
