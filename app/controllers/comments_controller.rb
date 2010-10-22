class CommentsController < ApplicationController
  
  def create
    @return_path = params[:comment].delete(:return_path)
    @article = Article.find(params[:comment][:article_id])
    
    comment_params = params[:comment]
    # Add all of the request values to the
    # comment params.
    comment_params[:user_ip] = request.remote_ip
    comment_params[:user_agent] = request.user_agent
    comment_params[:referrer] = request.referer
    comment_params[:permalink] = request.host + @return_path
    
    @comment = Comment.new(params[:comment])
    @comment.check_for_spam!
    
    respond_to do |wants|
      if @comment.save
        flash[:comment_notice] = 'Comment was successfully created.'
        wants.html { redirect_to(@return_path) }
        wants.xml { render :xml => @comment, :status => :created, :location => @comment }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
