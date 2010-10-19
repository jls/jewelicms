class CreateDataFields < ActiveRecord::Migration
  def self.up
    create_table :data_fields do |t|
      t.string :label
      t.integer :channel_id
      t.integer :data_field_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :data_fields
  end
end
