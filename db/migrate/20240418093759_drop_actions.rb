class DropActions < ActiveRecord::Migration[7.1]
  def up
    drop_table :actions
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
