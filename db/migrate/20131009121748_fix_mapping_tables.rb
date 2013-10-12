class FixMappingTables < ActiveRecord::Migration
  def change
    create_table :groups_users do |t|
      t.references :user
      t.references :group
    end
  end
end
