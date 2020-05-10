class CreateSnippets < ActiveRecord::Migration[6.0]
  def change
    create_table :snippets do |t|
      t.string :title
      t.string :type
      t.string :class
      t.text :raw
      t.text :notes

      t.timestamps
    end
  end
end
