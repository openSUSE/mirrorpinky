class CreateGroupRequests < ActiveRecord::Migration
  def change
    create_table :group_requests do |t|
      t.string :name
      t.references :user
      t.timestamps
    end
  end
end
