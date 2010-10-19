class ChangeCategoriesToOneToMany < ActiveRecord::Migration
  def self.up
    create_table :articles_categories do |t|
      t.integer :article_id
      t.integer :category_id
    end
    remove_column :articles, :category_id
  end

  def self.down    
    drop_table :articles_categories
    add_column :articles, :category_id, :integer
  end
  
end
