class Category < ActiveRecord::Base
  include Sluggable
  before_validation :generate_slug
  
  validates_uniqueness_of :slug, :scope => :channel_id, :on => :create, :message => "must be unique"
  
  belongs_to :channel
  has_and_belongs_to_many :articles
  named_scope :all_public, :order => "channel_id desc"
  
  protected
  
  def generate_slug
    self.slug = generate_slug_from :name if self.slug.blank?
  end
  
end
