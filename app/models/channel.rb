class Channel < ActiveRecord::Base
  
  include Sluggable
  before_validation :generate_slug
  
  validates_uniqueness_of :slug, :on => :create, :message => "must be unique"
  
  named_scope :all_public, :conditions => {:is_public => true}
  
  belongs_to :render_as, :class_name => "Channel", :foreign_key => "renders_as_channel_id"
  has_many :categories
  has_many :data_fields
  has_many :articles, :dependent => :destroy
  

  protected
  
  def generate_slug
    self.slug = generate_slug_from :name if self.slug.blank?
  end
  
end
