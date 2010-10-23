class AddCommentsEnabledToArticles < ActiveRecord::Migration
  def self.up
    
    add_column :articles, :comments_enabled, :boolean, :default => true
    
  end

  def self.down
    remove_column :articles, :comments_enabled
  end
end
