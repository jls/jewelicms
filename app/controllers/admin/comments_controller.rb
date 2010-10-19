class Admin::CommentsController < Admin::AdminController
  
  def index
    @comments = Comment.latest.paginate :page => params[:page]
  end
  
  def publish
    @comment = Comment.find(params[:id])
    @comment.update_attribute(:is_published, true)
    redirect_to admin_comments_path
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = 'Comment Destroyed'
    redirect_to admin_comments_path
  end
  
  def spam
    @comment = Comment.find(params[:id])
    # The user has said this is spam so 
    # if akismet is enabled and told us that 
    # it wasn't then we should be nice and let them know.
    if @comment.akismet_enabled? && !@comment.is_spam?
      @comment.spam!
    end
    # To just mark the comment as spam and not delete
    # the comment, uncomment following line and delete
    # everything until flash[:notice] line.
    # @comment.update_attribute :is_spam, true
    @comment.destroy
    
    flash[:notice] = 'Comment was marked as spam and deleted.'
    redirect_to admin_comments_path    
  end
  
  def not_spam
    @comment = comment.find(params[:id])
    # The user has said this is NOT spam
    # so if askimet is enabled and told us
    # that it was spam then we should let them know.
    if @comment.askimet_enabled? && @comment.is_spam?
      @comment.ham!
    end
    @comment.update_attribute :is_spam, false
    flash[:notice] = 'Comment was marked as NOT spam.'
    redirect_to admin_comments_path
  end
  
end