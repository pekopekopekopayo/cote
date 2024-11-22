class CreateExams < ActiveRecord::Migration[7.2]
  def change
    create_table :exams do |t|
      t.string :name, null: false
      t.integer :booked_count, default: 0, null: false
      t.datetime :start_at, null: false
      t.timestamps
    end
  end
end
