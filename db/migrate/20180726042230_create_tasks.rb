class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :user_id, null: true, default: nil
      t.string :name
      t.datetime :deadline

      t.timestamps
    end
  end
end
