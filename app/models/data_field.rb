class DataField < ActiveRecord::Base
  
  validates_presence_of :label, :channel_id, :data_field_type_id
  
  belongs_to :channel
  belongs_to :data_field_type
  has_many :data_values, :dependent => :destroy
  
  
end
