class DataFieldType < ActiveRecord::Base
  
  validates_presence_of :name
  has_many :data_fields
  
end
