class CreateAdminRsyncAcls < ActiveRecord::Migration
  def change
    create_table :rsync_acls do |t|
      t.string :host
      t.references :server, index: true

      t.timestamps
    end
  end
end
