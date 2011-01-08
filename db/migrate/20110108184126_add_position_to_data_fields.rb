class AddPositionToDataFields < ActiveRecord::Migration
  def self.up
    add_column :data_fields, :position, :integer
  end

  def self.down
    remove_column :data_fields, :position
  end
end