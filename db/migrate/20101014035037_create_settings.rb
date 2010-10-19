class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :site_name
      t.boolean :show_help, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
