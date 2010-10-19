class CreateDataFieldTypes < ActiveRecord::Migration
  def self.up
    create_table :data_field_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :data_field_types
  end
end
