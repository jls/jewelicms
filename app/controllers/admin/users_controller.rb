class Admin::UsersController < Admin::AdminController
  
  def index
    @users = User.find(:all)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      redirect_to admin_users_path
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    render(:action => 'new')
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    redirect_to admin_users_path
  end
  
  def destroy
    if User.count > 1
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "User Destroyed!"
    else
      flash[:notice] = "There must be at least 1 user so sorry, I can't delete that person."
    end
    redirect_to admin_users_path
  end
  
end