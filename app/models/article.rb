require 'jeweli_url'
class Article < ActiveRecord::Base

  cattr_accessor :per_page
  @@per_page = 30
  
  include Sluggable
  before_validation :generate_slug

  validates_presence_of :title
  validates_presence_of :channel_id
  validates_uniqueness_of :slug, :on => :create, :message => "must be unique"
  
  has_and_belongs_to_many :categories
  belongs_to :channel
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :comments
  has_many :data_values, :dependent => :destroy do
    def value_for label, filtered = true
      # Get the data field matching the label
      data_field = proxy_owner.channel.data_fields.find_by_label(label)
      return unless data_field
      
      value = find_by_data_field_id(data_field.id)
      return unless value
      
      (filtered) ? value.filtered_value : value.data_value
    end
  end
  
  scope :published, where(:is_published => true).order("articles.created_at DESC")
  
  accepts_nested_attributes_for :data_values
  
  # Builds a new article for the given channel.
  # The article will have data fields built as well.
  def self.new_for_channel channel, article_opts = {}
    article = Article.new({:channel_id => channel.id}.merge(article_opts))
    channel.data_fields.ordered.each do |data_field|
      article.data_values.build(
        :data_field => data_field, 
        :filter_id => data_field.default_filter_id
      )
    end
    article
  end
  
  # Stores a cache of the data values for this 
  # article for the life of this instance.  
  # This is really taken care of by ActiveRecord caching
  # but since we are planning on adding filtering
  # to these values later, it's not a bad idea to get
  # everyone using this method now.
  attr_accessor :values_cache
  
  # A convenience method to find the 
  # data value record for the data field
  # with the given label.
  def value_for label, filtered = true
    self.values_cache ||= {}
    self.values_cache["#{label}_#{filtered}"] ||= self.data_values.value_for(label, filtered)
    cached_value = self.values_cache["#{label}_#{filtered}"]
    (cached_value) ? cached_value.html_safe : cached_value
  end
  
  # Convenience method that combines most of the common
  # finder options into a single method.
  # 
  # Available Options:
  #   :from_url       -   A hash containing the url.  Usually `params`.
  #   :channel        -   String or Array of channel slugs.  This will limit the articles
  #                       returned to only the given channels.  This is an OR join so if you 
  #                       include more than one channel slug then all articles published to 
  #                       ANY of the channels will be returned. 
  #                       Example: :channel => :blog, Example: :channel => [:blog, :portfolio]
  #   :category       -   String or Array of category slugs.  This will limit the articles
  #                       returned to only the given categories.  This is an OR join so if you
  #                       include more than one category slug then all articles published to
  #                       ANY of the categories will be returned.
  #                       Example: :cateogory => 'general', Example: :category => ['general', 'ruby-on-rails']
  #   :limit          -   Number.  The maximum number of results to return. Default is no limit.
  #   :order          -   Symbol or String with values of "asc" or "desc" or :asc or :desc.
  #                       The default is :desc and this is always applied to the articles created at time.
  #   :per_page       -   Number.  The number of results you want returned. Default is no limit.
  #   :page           -   Number.  The number of the current page.  This is generally supplied
  #                       by params[:page] if you are using the will_paginate plugin. The default is 1.
  #   :published      -   true or false.  Defaults to true so only published articles will be returned.
  #   :slug           -   String.  Restricts results to articles (generally only 1) that match the given slug.
  #   :author         -   String.  The login of the author you want to restrict results to. 
  #
  # Examples:
  #   Get the *first* (not the latest) 5 articles that are published 
  #   to either the 'Blog' channel or the 'Gallery' channel.
  #       Article.get(:channel => [:blog, :gallery], :order => :asc, :limit => 5)
  #
  #   Get all articles published to the blog channel, in the general category
  #   showing 7 articles per page and using the will_paginate plugin.
  #       Article.get(:channel => :blog, :category => :general, :per_page => 7, :page => params[:page])
  #
  #   Get 1 article that matches the url created by using 
  #   the url helper: article_view_url(:renders_with => 'blog', :article_slug => article.slug)
  #       Article.get(:slug => params[:article_slug])
  def self.get options = {}
    opts = {
      :order => :desc,
      :published => true,
      :page => 1
    }.merge!(options) # User options win.
    
    if opts[:from_url]
      jeweli_url = JeweliUrl.new opts[:from_url]
      opts[:channel] = jeweli_url.channel.slug if jeweli_url.channel
      opts[:category] = jeweli_url.category.slug if jeweli_url.category
      opts[:slug] = jeweli_url.article.slug if jeweli_url.article
    end
    
    # Normalize a few of the options values to make sure
    # we either have a string or an array of strings.
    opts[:channel] = normalize_to_string(opts[:channel]) if opts[:channel]
    opts[:category] = normalize_to_string(opts[:category]) if opts[:category]
    opts[:author] = normalize_to_string(opts[:author]) if opts[:author]
    
    channels = opts[:channels].to_s if opts[:channels] && opts[:channels].is_a?(Symbol)

    current_scope = self.scoped 
    current_scope = current_scope.includes(:channel) if opts.include? :channel
    current_scope = current_scope.includes(:categories) if opts.include? :category
    current_scope = current_scope.includes(:author) if opts.include? :author

    current_scope = current_scope.limit(opts[:limit]) if opts.include? :limit
    
    # Add the sort
    current_scope = current_scope.order("articles.created_at #{opts[:order].to_s}")
    
    # Start building the conditions.
    current_scope = current_scope.where("articles.slug" => opts[:slug]) if opts.include? :slug
    current_scope = current_scope.where('channels.slug' => opts[:channel]) if opts.include? :channel
    current_scope = current_scope.where('categories.slug' => opts[:category]) if opts.include? :category
    current_scope = current_scope.where('users.login' => opts[:author]) if opts.include? :author
    current_scope = current_scope.where('articles.is_published' => opts[:published]) 
    

    if opts.include? :per_page
      current_scope.paginate(:per_page => opts[:per_page], :page => opts[:page])
    else
      current_scope
    end
    
  end
    
  protected
  
  # Accepts a string, symbol or array and converts into:
  # string -> string
  # symbol -> string
  # array of strings -> array of strings
  # array of symbols -> array of strings
  def self.normalize_to_string option
    if option
      option = option.to_s if option.is_a?(Symbol)
      option = option.collect{|o| o.to_s} if option.is_a?(Array)
    end
    option
  end
  
  def generate_slug
    self.slug = generate_slug_from :title if self.slug.blank?
  end
  
end
