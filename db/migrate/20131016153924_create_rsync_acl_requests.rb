class CreateRsyncAclRequests < ActiveRecord::Migration
  def change
    create_table :rsync_acl_requests do |t|
      t.string, :host
      t.references :server, index: true

      t.timestamps
    end
  end
end
