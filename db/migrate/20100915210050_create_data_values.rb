class CreateDataValues < ActiveRecord::Migration
  def self.up
    create_table :data_values do |t|
      t.integer :article_id
      t.integer :data_field_id
      t.string :data_value

      t.timestamps
    end
  end

  def self.down
    drop_table :data_values
  end
end
