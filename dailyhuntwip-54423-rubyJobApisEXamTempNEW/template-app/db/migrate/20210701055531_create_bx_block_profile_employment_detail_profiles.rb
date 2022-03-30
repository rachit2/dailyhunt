class CreateBxBlockProfileEmploymentDetailProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :employment_detail_profiles do |t|
      t.references :employment_detail, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
