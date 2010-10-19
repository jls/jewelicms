class Admin::AdminController < ApplicationController
  layout 'admin'
  
  include AuthenticatedSystem
  before_filter :login_required

  def index    
    # lw is array for :conditions to target 'last week'
    lw = ["created_at between ? and ?", Time.now-7.days, Time.now+1.day]
    @comments = Comment.latest.find(:all, :conditions => lw)
    @articles = Article.find(:all, :conditions => lw)
    @channels = Channel.find(:all, :conditions => lw)
    @users = User.find(:all, :conditions => lw)
  end
end