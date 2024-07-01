class AddImageToGig < ActiveRecord::Migration[7.1]
  def change
    add_column :gigs, :image, :string
  end
end
