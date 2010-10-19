class HomeController < ApplicationController
  
  def index
    @channels = Channel.all_public
    render :template => "templates/index"
  end
  
end
