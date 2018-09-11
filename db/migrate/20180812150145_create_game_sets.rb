class CreateGameSets < ActiveRecord::Migration[5.1]
  def change
    create_table :game_sets, id: :uuid do |t|
      t.uuid :match_id,         null: false
      t.integer :position,      null: false
      t.integer :score,         array: true, null: false, default: []

      t.timestamps
    end

    add_index :game_sets, :match_id
  end
end
