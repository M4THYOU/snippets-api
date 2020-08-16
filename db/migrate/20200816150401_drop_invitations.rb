class DropInvitations < ActiveRecord::Migration[6.0]
  def up
    drop_table :invitations
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
