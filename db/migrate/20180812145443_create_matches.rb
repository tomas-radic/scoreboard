class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches, id: :uuid do |t|
      t.string :participant1,     null: false
      t.string :participant2,     null: false
      t.integer :position,        null: false
      t.datetime :not_before
      t.datetime :started_at
      t.datetime :finished_at
      t.uuid :court_id,           null: false

      t.timestamps
    end
  end
end
