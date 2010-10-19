class AddIsPublishedToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :is_published, :boolean, :default => false
  end

  def self.down
    remove_column :comments, :is_published
  end
end
