class AddParentIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :parent_id, :integer
  end
end
