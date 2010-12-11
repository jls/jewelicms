require 'jeweli_url'
class ChannelController < ApplicationController

  def home
    @channels = Channel.all_public
    render :template => "templates/index", :layout => !request.xhr?
  end
  
  def index
    
    @jeweli_url = JeweliUrl.new params, current_user.nil?
    @channel = @jeweli_url.channel
    # We don't have a channel that matches the renders_with param
    # so we render a matching template in the templates directory.
    render_standalone_template and return unless @channel

    @render_as = @channel.render_as || @channel
    
    load_records_for_channel if @jeweli_url.is_channel_page?
    load_records_for_category if @jeweli_url.is_category_page?
    (load_records_for_article && render(:action => :article_by_slug, :layout => !request.xhr?)) and return if @jeweli_url.is_article_page?
    
    respond_to do |wants|
      wants.html {
        render(:layout => !request.xhr?)
      }
      wants.rss
    end
  end
  
  protected 
  
  def load_records_for_channel
    @categories = @channel.categories
    @articles = @channel.articles.published
    @articles = @articles.paginate(:page => params[:page]) if request.format.html?
  end
  
  def load_records_for_category
    @category = @jeweli_url.category
    @categories = [@category]
    @articles = @category.articles.published
    @articles = @articles.paginate(:page => params[:page]) if request.format.html?
  end
  
  def load_records_for_article
    @article = @jeweli_url.article
  end
  
  # Attempts to render a template in the templates directory
  # that matches the renders_with parameter.  If the template
  # doesn't exist then a redirect to 404.html is performed.
  def render_standalone_template
    begin
      return render(:template => "templates/#{params[:renders_with]}", :layout => !request.xhr?) 
    rescue ActionView::MissingTemplate
      redirect_to('/404.html')
    end
  end
  
end
