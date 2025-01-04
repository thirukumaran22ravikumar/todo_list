class CreateWorkspaceMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :workspace_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workspace, null: false, foreign_key: true
      t.integer :role, default: 0 
      t.timestamps
    end
  end
end
