class JeweliUrl
  
  attr_accessor   :params, :only_public
  
  attr_accessor   :template,
                  :channel, 
                  :category, 
                  :article, 
                  :day, 
                  :month, 
                  :year,
                  :extra_parts
  
  # Initializes the url interpreter with 
  # the current url params.
  def initialize params, only_public = true
    self.params = params.dup
    self.only_public = only_public
    self.interpret
  end
  
  # A few helper methods that can help
  # determine if the url has been interpreted
  # as a channel page, category page or article page.
  def is_channel_page?
    (channel && !category && !article)
  end
  
  def is_category_page?
    (category && !article)
  end
  
  def is_article_page?
    (article)
  end
  
  
  protected
  
  # Interpret will recongnize the following url
  # and translate them as documented:
  #
  # => /blog
  #     Interpreted as #template => blog
  # => /template/article-slug
  # => /template/article-slug/some/other/parameters
  # => /template/category-name
  def interpret
    url_params = self.params
    return unless url_params
    
    # parts is now a string instead of an array so we will split
    # it ourselves.
    if parts = url_params[:parts]
      parts = parts.split('/') if parts
    end
    
    # The render template will always be stored
    # in the renders_with option in the params.
    template = url_params[:renders_with]
    
    # We will also see if there is a channel 
    # with the same name as the template.
    self.channel = ((only_public) ? Channel.all_public.find_by_slug(template) : Channel.find_by_slug(template)) if template
    
    return unless parts && parts.size > 0
    
    # first part after the template can either be
    # an article (which will take precedence over a category),
    # a category (which will take precedence over a date),
    # or a year
    first_part = parts.shift
        
    self.article = (only_public) ? Article.published.find_by_slug(first_part) : Article.find_by_slug(first_part)
    
    # If we have an article then we we will remove the article
    # slug part and save the rest of the parts in extra_parts
    self.extra_parts = parts if self.article
    return if self.article
    
    # The first part could also be a category if it wasn't
    # an article.
    self.category = Category.find_by_slug(first_part)
    # If we have a category then unless the 
    # next part is a date then we are done.
    self.extra_parts = parts if self.category
    
        
  end
  
  
end