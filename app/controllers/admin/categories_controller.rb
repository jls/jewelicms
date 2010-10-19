class Admin::CategoriesController < Admin::AdminController
  
  def index
    @categories = Category.all_public
  end
  
  def new 
    @category = Category.new(:channel_id => params[:channel_id])
  end
  
  def create
    @category = Category.new(params[:category])
    
    respond_to do |wants|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        wants.html { redirect_to(admin_categories_path) }
        wants.xml { render :xml => @category, :status => :created, :location => @category }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @category = Category.find(params[:id])
    render :action => 'new'
  end
  
  def update
    @category = Category.find(params[:id])
    @category.update_attributes params[:category]
    flash[:notice] = 'Category updated'
    redirect_to admin_categories_path
  end
  
end
