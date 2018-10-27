class ChangeMatchesNotBeforeType < ActiveRecord::Migration[5.1]
  def change
    remove_column :matches, :not_before, :time
    add_column :matches, :not_before, :datetime
  end
end
