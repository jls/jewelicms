class Admin::DataFieldsController < Admin::AdminController
  
  def index
    if params[:channel_id]
      @data_fields = Channel.find(params[:channel_id]).data_fields
    else
      @data_fields = DataField.all
    end
  end

  def new
    @data_field = DataField.new(:channel_id => params[:channel_id])
  end
  
  def edit
    @data_field = DataField.find(params[:id])
    render :action => 'new'
  end
  
  def create
    @data_field = DataField.new(params[:data_field])
    
    respond_to do |wants|
      if @data_field.save
        flash[:notice] = 'Data Field was successfully created.'
        wants.html { redirect_to(admin_data_fields_path) }
        wants.xml { render :xml => @data_field, :status => :created, :location => @data_field }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @data_field.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @data_field = DataField.find(params[:id])
    @data_field.update_attributes(params[:data_field])
    flash[:notice] = 'Updated Data Field'
    redirect_to admin_data_fields_path
  end
  
  def destroy
    @data_field = DataField.find(params[:id])
    @data_field.destroy
    flash[:notice] = "Data Field was Destroyed"
    redirect_to admin_data_fields_path
  end
  
  
end
