class CreateLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :links do |t|
      t.string :gig_id
      t.integer :user_id
      t.string :text

      t.timestamps
    end
  end
end
