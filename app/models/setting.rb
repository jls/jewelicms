class Setting < ActiveRecord::Base
  
  DEFAULTS = {:site_name => 'Jeweli', :show_help => true}
  
  def self.default
    # Check and see if settings exist
    # and if so retrieve them otherwise
    # create and return.
    if self.count == 0
      self.create(DEFAULTS)
    end
    self.find(:first)
  end
  
end
