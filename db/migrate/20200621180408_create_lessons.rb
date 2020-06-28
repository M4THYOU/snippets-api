class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.string :title
      t.string :type
      t.string :class
      t.text :canvas

      t.timestamps
    end
  end
end
