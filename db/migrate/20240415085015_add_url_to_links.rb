class AddUrlToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :url, :string
  end
end
