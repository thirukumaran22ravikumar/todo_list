class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.datetime :due_date
      t.integer :priority
      t.datetime :remind_before_at
      t.integer :assignee_id
      t.boolean :completion_status
      # t.references :categories, null: false, foreign_key: true

      t.timestamps
    end
  end
end
