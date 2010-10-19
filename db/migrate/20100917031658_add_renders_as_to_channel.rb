class AddRendersAsToChannel < ActiveRecord::Migration
  def self.up
    add_column :channels, :renders_as_channel_id, :integer
  end

  def self.down
    remove_column :channels, :renders_as_channel_id
  end
end
