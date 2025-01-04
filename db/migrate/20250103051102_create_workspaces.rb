class CreateWorkspaces < ActiveRecord::Migration[7.1]
  def change
    create_table :workspaces do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.string :api_key, null: false

      t.timestamps
    end
    # Add a unique index for the api_key column
    add_index :workspaces, :api_key, unique: true
  end
  
end
