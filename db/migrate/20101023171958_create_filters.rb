class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :filters do |t|
      t.string :name
      t.timestamps
    end
    
    # Add the default Markdown filter
    unless filter = Filter.find_by_name('Markdown')
      Filter.create(:name => 'Markdown')
    end
    
  end

  def self.down
    drop_table :filters
  end
end
