class CreateGigs < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto'
    create_table :gigs, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.integer :user_id
      t.string :summary
      t.date :start_date
      t.date :end_date
      t.string :location

      t.timestamps
    end
  end
end
