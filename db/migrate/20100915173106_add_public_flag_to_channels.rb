class AddPublicFlagToChannels < ActiveRecord::Migration
  def self.up
    add_column :channels, :is_public, :boolean
  end

  def self.down
    remove_column :channels, :is_public
  end
end
