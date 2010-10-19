class DataValue < ActiveRecord::Base
  
  validates_presence_of :article_id, :data_field_id, :data_value
  
  belongs_to :article
  belongs_to :data_field
    
end
