class Admin::ArticlesController < Admin::AdminController
  
  def index
    @articles = Article.paginate :page => params[:page], :order => "created_at DESC"
  end
  
  def new
    @article = Article.new(:channel_id => params[:channel_id])
  end
  
  def create
    @data_values = params.delete(:data_values)
    @article = Article.create(params[:article])
    @article.update_attribute(:author_id, current_user.id)
    
    # Save all of the data values
    if @data_values
      @data_values.each do |k,v|
        data_field = DataField.find(k.to_i)
        @article.data_values.create(:data_field_id => data_field.id, :data_value => v)
      end 
    end
    respond_to do |wants|
      if @article
        flash[:notice] = 'Article was successfully created.'
        wants.html { redirect_to(admin_articles_path) }
        wants.xml { render :xml => @article, :status => :created, :location => @article }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  def edit
    @article = Article.find(params[:id])
    render :action => 'new'
  end
  
  def update
    @article = Article.find(params[:id])
    @article.update_attributes(params[:article])
    
    # Update the data values
    @data_values = params[:data_values]
    if @data_values
      @data_values.each do |k,v|
        data_field = DataField.find(k.to_i)
        if existing_data_value = @article.data_values.find_by_data_field_id(data_field.id)
          existing_data_value.update_attribute(:data_value, v)
        else
          @article.data_values.create(:data_field_id => data_field.id, :data_value => v)
        end
      end
    end    
    flash[:notice] = 'Article Updated'
    redirect_to admin_articles_path
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = 'Article Destroyed.'
    redirect_to admin_articles_path
  end
  
end
