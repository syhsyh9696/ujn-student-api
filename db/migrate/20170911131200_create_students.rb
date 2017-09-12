class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string :stu_name
      t.string :stu_num
      t.string :stu_id
      t.string :stu_gender
      t.string :stu_tel
      t.timestamps
    end
  end
end
