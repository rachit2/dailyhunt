class RenameBxBlockProfileUniversityToUniversity < ActiveRecord::Migration[6.0]
  def change
  	rename_table :bx_block_profile_universities, :universities
  end
end
