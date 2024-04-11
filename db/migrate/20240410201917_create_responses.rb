class CreateResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :responses do |t|
      t.integer :user_id
      t.string :gig_id
      t.string :status

      t.timestamps
    end
  end
end
