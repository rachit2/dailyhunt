class RenameBxBlockProfileCollegeAndDegreeToCollegeAndDegree < ActiveRecord::Migration[6.0]
  def change
  	rename_table :bx_block_profile_college_and_degrees, :college_and_degrees
  end
end
