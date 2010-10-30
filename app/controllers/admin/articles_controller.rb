class Admin::ArticlesController < Admin::AdminController
  
  def index
    @articles = Article.paginate :page => params[:page], :order => "created_at DESC"
  end
  
  def new
    @article = current_user.articles.new(:channel_id => params[:channel_id], :is_published => true)
    @data_values = {}
    @filters = {}
  end
  
  def create
    @data_values = params.delete(:data_values)
    @filters = params.delete(:filters)
    @article = Article.create(params[:article])
    if @article.errors.empty?
      @article.update_attribute(:author_id, current_user.id)
    
      # Save all of the data values
      if @data_values
        @data_values.each do |k,v|
          data_field = DataField.find(k.to_i)
          filter_id = (@filters.nil? || @filters[k].blank?) ? nil : @filters[k].to_i
          @article.data_values.create(:data_field_id => data_field.id, :data_value => v, :filter_id => filter_id)
        end 
      end
    end
    respond_to do |wants|
      if @article.valid?
        flash[:notice] = 'Article was successfully created.'
        wants.html { 
          if params[:preview_option]
            redirect_to edit_admin_article_path(@article, :preview => 1)
          else  
            redirect_to(admin_articles_path) 
          end
        }
        wants.xml { render :xml => @article, :status => :created, :location => @article }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  def edit
    @article = Article.find(params[:id])
    @data_values = @filters = {}
    render :action => 'new'
  end
  
  def update
    @filters = params.delete(:filters)
    @data_values = params.delete(:data_values)
    
    @article = Article.find(params[:id])
    @article.update_attributes(params[:article])
    
    # Update the data values
    if @data_values
      @data_values.each do |k,v|
        data_field = DataField.find(k.to_i)
        filter_id = (@filters.nil? || @filters[k].blank?) ? nil : @filters[k].to_i
        if existing_data_value = @article.data_values.find_by_data_field_id(data_field.id)
          existing_data_value.update_attribute(:data_value, v)
          existing_data_value.update_attribute(:filter_id, filter_id)
        else
          @article.data_values.create(:data_field_id => data_field.id, :data_value => v, :filter_id => filter_id)
        end
      end
    end    
    flash[:notice] = 'Article Updated'
    if params[:preview_option]
      redirect_to edit_admin_article_path(@article, :preview => 1)
    else
      redirect_to admin_articles_path
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = 'Article Destroyed.'
    redirect_to admin_articles_path
  end
  
end
