class AddAuthorInBlog < ActiveRecord::Migration[6.0]
  def change
    add_reference :contents, :author, foreign_key: true
  end
end
