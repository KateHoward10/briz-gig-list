class AddImageToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :image, :string
  end
end
