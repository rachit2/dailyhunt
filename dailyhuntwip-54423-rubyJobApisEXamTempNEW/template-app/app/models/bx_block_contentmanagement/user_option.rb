# == Schema Information
#
# Table name: user_options
#
#  id               :bigint           not null, primary key
#  is_true          :boolean
#  optionable_type  :string
#  rank             :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  option_id        :bigint           not null
#  optionable_id    :integer
#  test_question_id :bigint           not null
#
# Indexes
#
#  index_user_options_on_option_id         (option_id)
#  index_user_options_on_test_question_id  (test_question_id)
#
# Foreign Keys
#
#  fk_rails_...  (option_id => options.id)
#  fk_rails_...  (test_question_id => test_questions.id)
#
module BxBlockContentmanagement
  class UserOption < ApplicationRecord
    self.table_name = :user_options
    
    belongs_to :test_question
    belongs_to :option
    belongs_to :optionable, polymorphic: true
    after_save :update_rank

    validates_uniqueness_of :optionable_id, :scope => [:optionable_type, :test_question_id]

    private 

    def update_rank
      total = self.optionable.user_options.where(is_true: true).count
      self.optionable.update(total: total)
    end

    def self.rank(optionable_type, optionable)
      if optionable_type == 'quiz'
        quiz_ranks= ActiveRecord::Base.connection.execute("SELECT *, rank() OVER (ORDER BY total DESC)rnk  FROM user_quizzes")
        u_quiz = quiz_ranks.detect {|e| e["id"] == optionable.id}
        u_quiz["rnk"]
      else
        assessment_ranks = ActiveRecord::Base.connection.execute("SELECT *, rank() OVER (ORDER BY total DESC)rnk  FROM user_assessments")
        u_assessment = assessment_ranks.detect {|e| e["id"] == optionable.id}
        u_assessment["rnk"]
      end
    end
  end
end
