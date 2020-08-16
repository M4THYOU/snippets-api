class AddIsInvitedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_invited, :boolean, default: false
  end
end
