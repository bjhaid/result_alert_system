class CreateStudent < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :matric_no
      t.string :name
      t.string :phone_number
      t.string :email
      t.timestamps
    end
  end
end
