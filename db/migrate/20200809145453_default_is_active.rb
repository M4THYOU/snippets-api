class DefaultIsActive < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :is_active, false, default: 0
  end
end
