class AddPublicKeyToCourts < ActiveRecord::Migration[5.1]
  def change
    add_column :courts, :public_key, :string
  end
end
