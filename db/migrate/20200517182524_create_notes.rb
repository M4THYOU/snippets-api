class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.integer :snippet_id
      t.text :text

      t.timestamps
    end
  end
end
