class Admin::AdminController < ApplicationController
  layout 'admin'
  
  include AuthenticatedSystem
  before_filter :login_required

  def index    
    # lw is array for :conditions to target 'last week'
    lw = ["created_at between ? and ?", Time.now-7.days, Time.now+1.day]
    @comments = Comment.latest.where(lw)
    @articles = Article.where(lw)
    @channels = Channel.where(lw)
    @users = User.where(lw)
  end
  
  helper_method :is_mobile?
  def is_mobile?
    (request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/])
  end
  
end