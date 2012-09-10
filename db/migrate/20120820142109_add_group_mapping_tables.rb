class AddGroupMappingTables < ActiveRecord::Migration
  def up
    create_table :users_groups do |t|
      t.references :users
      t.references :groups
    end
    create_table :groups_servers do |t|
      t.references :groups
      t.references :servers
    end
    add_index :users_groups,   :users_id
    add_index :users_groups,   :groups_id
    add_index :groups_servers, :groups_id
    add_index :groups_servers, :servers_id
  end

  def down
    drop_table :users_groups
    drop_table :groups_servers
  end
end
