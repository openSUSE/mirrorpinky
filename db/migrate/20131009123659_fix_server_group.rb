class FixServerGroup < ActiveRecord::Migration
  def change
    create_table :groups_server do |t|
      t.references :group
      t.references :server
    end
  end
end
