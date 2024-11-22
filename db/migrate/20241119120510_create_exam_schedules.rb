class CreateExamSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :exam_schedules do |t|
      t.integer :exam_id, null: false
      t.integer :user_id, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end

    add_index :exam_schedules, :exam_id
    add_index :exam_schedules, :user_id
  end
end
