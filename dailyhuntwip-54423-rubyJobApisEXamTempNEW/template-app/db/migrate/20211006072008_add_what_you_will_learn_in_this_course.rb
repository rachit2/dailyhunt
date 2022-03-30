class AddWhatYouWillLearnInThisCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :what_you_will_learn_in_this_course, :text
  end
end
