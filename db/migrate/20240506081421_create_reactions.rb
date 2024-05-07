class CreateReactions < ActiveRecord::Migration[7.1]
  def change
    create_table :reactions do |t|
      t.string :emoji
      t.integer :post_id
      t.integer :user_id

      t.timestamps
    end
  end
end
