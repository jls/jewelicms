class AddFilterToDataValues < ActiveRecord::Migration
  def self.up
    add_column :data_values, :filter_id, :integer
  end

  def self.down
    remove_column :data_values, :filter_id
  end
end
