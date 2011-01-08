class Admin::ArticlesController < Admin::AdminController
  
  def index
    @articles = Article.includes(:comments, :channel, :categories, :author).paginate :page => params[:page], :order => "created_at DESC"
  end
  
  def new
    @channel = Channel.find(params[:channel_id])
    @article = current_user.articles.new(:channel => @channel, :is_published => true)
    # Add the default data fields defined for this channel
    @channel.data_fields.ordered.each do |data_field|
      @article.data_values.build(
        :data_field => data_field,
        :filter_id => data_field.default_filter_id
      )
    end
    @data_values = {}
    @filters = {}
  end
  
  def create
    @article = Article.new(params[:article])
    respond_to do |wants|
      if @article.save
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
    render :action => 'new'
  end
  
  def update
    @article = Article.find(params[:id])
    @article.update_attributes(params[:article])
    
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
