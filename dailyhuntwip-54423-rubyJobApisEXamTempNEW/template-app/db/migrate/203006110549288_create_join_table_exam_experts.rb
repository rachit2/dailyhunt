class CreateJoinTableExamExperts < ActiveRecord::Migration[6.0]
  def change
    create_join_table :exams, :career_experts do |t|
      # t.index [:exam_id, :career_expert_id]
      # t.index [:career_expert_id, :exam_id]
    end
  end
end
