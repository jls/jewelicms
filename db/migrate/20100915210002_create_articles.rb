class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.integer :channel_id
      t.boolean :is_published

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
