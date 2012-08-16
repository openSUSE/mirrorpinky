class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :title

      t.timestamps
    end
    add_index :roles, :title
  end
end
