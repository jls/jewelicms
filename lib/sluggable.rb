module Sluggable
  
  def generate_slug_from from_field
    #strip the string
    ret = self.send(from_field).downcase.strip

    #blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with dash
    ret.gsub! /\s*[^A-Za-z0-9\.\_]\s*/, '-'  

    #convert double underscores to single
    ret.gsub! /_+/,"-"

    #strip off leading/trailing underscore
    ret.gsub! /\A[-\.]+|[-\.]+\z/,""

    ret
  end
  
end