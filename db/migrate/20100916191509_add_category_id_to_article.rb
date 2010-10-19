class AddCategoryIdToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :category_id, :integer
  end

  def self.down
    remove_column :articles, :category_id
  end
end
