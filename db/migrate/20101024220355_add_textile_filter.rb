class AddTextileFilter < ActiveRecord::Migration
  def self.up

    # Add the default Markdown filter
    unless filter = Filter.find_by_name('Textile')
      Filter.create(:name => 'Textile')
    end
    
  end

  def self.down
    Filter.destroy(:name => 'Textile')
  end
end
