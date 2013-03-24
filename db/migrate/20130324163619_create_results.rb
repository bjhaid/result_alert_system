class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :course_name
      t.string :course_title
      t.integer :student_id
      t.integer :score
      t.timestamps
    end
  end
end
