class CreateCourts < ActiveRecord::Migration[5.1]
  def change
    create_table :courts, id: :uuid do |t|
      t.string :label,        null: false
      t.uuid :tournament_id,  null: false

      t.timestamps
    end

    add_index :courts, :tournament_id
  end
end
