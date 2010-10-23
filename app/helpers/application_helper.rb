# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Request from an iPhone or iPod touch? (Mobile Safari user agent)
  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end
    
  def select_options collection, id = "id", name = "name"
    options_from_collection_for_select(collection, id, name)
  end
  
  # helpers for building urls
  def channel_url(channel, include_host = false)
    if include_host
      channel_by_slug_url(channel.slug)
    else
      channel_by_slug_path(channel.slug)
    end
  end
  
  def category_url(category, include_host = false)
    channel_slug = category.channel.slug
    if include_host
      category_by_slug_url(channel_slug, category.slug)
    else
      category_by_slug_path(channel_slug, category.slug)
    end
  end
  
  def article_url(article, include_host = false)
    channel_slug = article.channel.slug
    if include_host
      article_by_slug_url(:channel_slug => channel_slug, :article_slug => article.slug)
    else
      article_by_slug_path(:channel_slug => channel_slug, :article_slug => article.slug)
    end
  end
  
end
