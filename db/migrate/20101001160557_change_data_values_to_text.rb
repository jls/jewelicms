class ChangeDataValuesToText < ActiveRecord::Migration
  def self.up
    change_column :data_values, :data_value, :text
  end

  def self.down
    change_column :data_values, :data_value, :string
  end
end
