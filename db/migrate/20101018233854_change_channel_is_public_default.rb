class ChangeChannelIsPublicDefault < ActiveRecord::Migration
  def self.up
    change_column :channels, :is_public, :boolean, :default => true
  end

  def self.down
    change_column :channels, :is_public, :boolean, :default => false
  end
end
