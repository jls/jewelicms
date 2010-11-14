class Comment < ActiveRecord::Base
  
  @@akismet_enabled = Rakismet::Base.valid_key?
  
  if @@akismet_enabled
    include Rakismet::Model
    rakismet_attrs  :author => :name,
                    :author_email => :email,
                    :author_url => :url,
                    :content => :body
  end
  
  # Pagination
  cattr_accessor :per_page
  @@per_page = 10
  
  validates_presence_of :name, :email, :body, :article_id
  belongs_to :article
  
  scope :published, where(:is_published => true)
  scope :latest, order("created_at DESC")
  
  def check_for_spam!
    # If the Raskismet key is not
    # set then we have to say no this
    # is not spam.
    possible_spam = false
    if akismet_enabled?
      possible_spam = self.spam?
    end
    update_attribute :is_spam, possible_spam
    possible_spam
  end
  
  #
  # Methods for Akismet spam checks
  #
  def akismet_enabled?
    @@akismet_enabled
  end
  
  def comment_type
    'comment'
  end
    
end
