class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :text
      t.string :uuid
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
