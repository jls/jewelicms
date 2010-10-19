class AddIndexToSlugs < ActiveRecord::Migration
  def self.up
    add_index :channels, :slug, :unique => true
    add_index :articles, :slug, :unique => true
    add_index :categories, :slug, :unique => true
  end

  def self.down
    
  end
end
