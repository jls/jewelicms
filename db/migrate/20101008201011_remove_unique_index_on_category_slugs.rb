class RemoveUniqueIndexOnCategorySlugs < ActiveRecord::Migration
  def self.up
    remove_index :categories, :slug
    add_index :categories, :slug, :unique => false
  end

  def self.down
    remove_index :categories, :slug
    add_index :categories, :slug, :unique => true
  end
end
