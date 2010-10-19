class Admin::ChannelsController < Admin::AdminController
  
  def index
    @channels = Channel.find(:all)
  end

  def new 
   @channel = Channel.new
  end

  def create
   @channel = Channel.new(params[:channel])

   if params[:copy] && !params[:copy][:channel_id].blank?
     copy_channel = Channel.find(params[:copy][:channel_id])
     if copy_channel
       copy_channel.data_fields.each do |df|
         @channel.data_fields.build(df.attributes)
       end
     end
   end

   respond_to do |wants|
     if @channel.save
       flash[:notice] = 'Channel was successfully created.'
       wants.html { redirect_to(admin_channels_path) }
       wants.xml { render :xml => @channel, :status => :created, :location => @channel }
     else
       wants.html { render :action => "new" }
       wants.xml { render :xml => @channel.errors, :status => :unprocessable_entity }
     end
   end
  end
  
  def edit
    @channel = Channel.find(params[:id])
  end
  
  def update
    @channel = Channel.find(params[:id])
    @channel.update_attributes(params[:channel])
    flash[:notice] = 'Updated Channel'
    redirect_to admin_channels_path
  end

  def show
    @channel = Channel.find(params[:id])
  end
  
  def destroy
    @channel = Channel.find(params[:id])
    @channel.destroy
    flash[:notice] = "Channel was destroyed."
    redirect_to admin_channels_path
  end
  
end
