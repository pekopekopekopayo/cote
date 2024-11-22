class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.timestamps
      t.string :name
      t.integer :role, default: 0, null: false
    end
  end
end