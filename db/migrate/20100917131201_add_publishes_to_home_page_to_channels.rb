class AddPublishesToHomePageToChannels < ActiveRecord::Migration
  def self.up
    add_column :channels, :publishes_to_home_page, :boolean
  end

  def self.down
    remove_column :channels, :publishes_to_home_page
  end
end
