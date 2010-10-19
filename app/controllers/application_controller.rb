# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  helper_method :article_permalink
  def article_permalink article
    channel_slug = article.channel.slug
    category_slug = article.category.slug
    article_by_slug_url(:channel_slug => channel_slug, :category_slug => category_slug, :article_slug => article.slug)
  end

  helper_method :category_permalink
  def category_permalink category
    
  end
  
  helper_method :channel_permalink
  def channel_permalink
  end
  
end
