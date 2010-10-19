class AddIsSpamFlagToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :is_spam, :boolean
  end

  def self.down
    remove_column :comments, :is_spam 
  end
end
