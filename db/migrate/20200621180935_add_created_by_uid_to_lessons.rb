class AddCreatedByUidToLessons < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :created_by_uid, :integer
  end
end
