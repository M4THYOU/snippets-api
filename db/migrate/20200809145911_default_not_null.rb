class DefaultNotNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :is_active, false, 0
  end
end
