class Filter < ActiveRecord::Base
  
  has_many :data_values
  has_many :data_fields_as_default, :class_name => 'DataField', :foreign_key => 'default_filter_id'

  def self.to_dropdown
    self.all.collect{|f|
      [f.name, f.id]
    }
  end
  
end
