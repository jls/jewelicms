class DataValue < ActiveRecord::Base
  
  validates_presence_of :data_field_id
  validates_associated :article
  
  belongs_to :article
  belongs_to :data_field
  belongs_to :filter
   
  def filtered_value
    return data_value unless filter
    return markdowned_value if filter.name == "Markdown"
    return textiled_value if filter.name == "Textile"
  end
  
  protected
  
  def markdowned_value
    RDiscount.new(self.data_value).to_html if self.data_value
  end
  
  def textiled_value
    RedCloth.new(self.data_value).to_html
  end
  
end
