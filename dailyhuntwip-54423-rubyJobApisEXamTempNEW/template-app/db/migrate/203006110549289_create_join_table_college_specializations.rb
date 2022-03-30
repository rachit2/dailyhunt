class CreateJoinTableCollegeSpecializations < ActiveRecord::Migration[6.0]
  def change
    create_join_table :colleges, :specializations do |t|
      # t.index [:college_id, :specialization_id]
      # t.index [:specialization_id, :college_id]
    end
  end
end
