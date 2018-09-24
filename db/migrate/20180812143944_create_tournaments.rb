class CreateTournaments < ActiveRecord::Migration[5.1]
  def change
    create_table :tournaments, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :label, null: false
      t.boolean :public_score_update, null: false, default: true
      t.datetime :approved_at

      t.timestamps
    end

    add_index :tournaments, :user_id
  end
end
