class AddClolumnToTask < ActiveRecord::Migration[7.1]
  def change
    add_column  :tasks, :category_id ,:integer
    add_column  :categories, :workspace_id ,:integer
  end
end
