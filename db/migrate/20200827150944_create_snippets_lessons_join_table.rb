class CreateSnippetsLessonsJoinTable < ActiveRecord::Migration[6.0]
  def change
    # create_join_table :snippets, :lessons

    create_join_table :snippets, :lessons do |t|
      t.index :snippet_id
      t.index :lesson_id
    end
  end
end
