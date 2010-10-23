class DataValue < ActiveRecord::Base
  
  validates_presence_of :article_id, :data_field_id, :data_value
  
  belongs_to :article
  belongs_to :data_field
  belongs_to :filter
   
  def filtered_value
    return data_value unless filter
    return markdowned_value if filter.name == "Markdown"
  end
  
  protected
  
  def markdowned_value
    RDiscount.new(self.data_value).to_html
  end
  
end
