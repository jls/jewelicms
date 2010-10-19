class RemovePrimaryFromArticlesCategories < ActiveRecord::Migration
  def self.up
    
    remove_column :articles_categories, :id
    
  end

  def self.down
  end
end
