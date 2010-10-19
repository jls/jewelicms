class AddUserToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :user_id, :integer
  end

  def self.down
    add_column :settings, :user_id
  end
end
