class AddDefaultFilterToDataFields < ActiveRecord::Migration
  def self.up
    add_column :data_fields, :default_filter_id, :integer
  end

  def self.down
    remove_column :data_fields, :default_filter_id
  end
end
