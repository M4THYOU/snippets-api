class CreateInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :invitations do |t|
      t.string :secret_key
      t.datetime :used_at
      t.integer :created_by_uid
      t.string :email
      t.text :meta

      t.timestamps
    end
  end
end
