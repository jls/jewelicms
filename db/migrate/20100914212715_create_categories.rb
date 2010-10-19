class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :channel_id
      t.string :name
      t.string :slug

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
