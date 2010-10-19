class AddUserIdToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :author_id, :integer
  end

  def self.down
    remove_column :articles, :author_id
  end
end
