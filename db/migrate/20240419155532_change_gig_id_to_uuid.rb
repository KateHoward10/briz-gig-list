class ChangeGigIdToUuid < ActiveRecord::Migration[7.1]
  def up
    execute "ALTER TABLE responses ALTER COLUMN gig_id TYPE uuid USING gig_id::uuid;"
    execute "ALTER TABLE posts ALTER COLUMN gig_id TYPE uuid USING gig_id::uuid;"
    execute "ALTER TABLE links ALTER COLUMN gig_id TYPE uuid USING gig_id::uuid;"
  end

  def down
    change_column :responses, :gig_id, :string
    change_column :posts, :gig_id, :string
    change_column :links, :gig_id, :string
  end
end
