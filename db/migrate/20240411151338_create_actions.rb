class CreateActions < ActiveRecord::Migration[7.1]
  def change
    create_table :actions do |t|
      t.integer :user_id
      t.string :gig_id
      t.string :gig_name
      t.string :kind
      t.string :status
      t.text :text

      t.timestamps
    end
  end
end
