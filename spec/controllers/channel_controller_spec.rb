require File.dirname(__FILE__) + '/../spec_helper'

describe ChannelController do
  render_views
  
  def create_template(filename)
    File.open(Rails.root + 'app/views/templates/' + filename, 'w') {|f| f.write("Template #{filename}") }
  end
  
  def remove_template(filename)
    File.delete(Rails.root + 'app/views/templates/' + filename)
  end
  
  def testing_templates
    ['tarchive.html.erb', 'tblog.html.erb', '_tprojects_item.html.erb', '_tprojects_list.html.erb']
  end
  
  before(:each) do
    # Create the templates for these tests
    testing_templates.each do |t|
      create_template(t)
    end
  end
  
  after(:each) do
    testing_templates.each do |t|
      remove_template(t)
    end
  end
  
  it "home action should render index template" do
    get :home
    response.should render_template('templates/index')
  end
  
  context :index_action do
  
    it "should render template if no channel exists" do
      get :index, :renders_with => 'tarchive'
      response.should render_template('templates/tarchive')
    end
  
    it "should render index template if channel exists" do
      @channel = Factory(:channel, :name => 'TProjects', :slug => 'tprojects')
      @article = Factory(:article, :channel => @channel)
      get :index, :renders_with => 'tprojects'
      response.should render_template('index')
      response.should contain("Template _tprojects_list.html.erb")
    end
  
    it "should render index template if channel exists and category exists" do
      @channel = Factory(:channel, :name => 'TProjects', :slug => 'tprojects')
      @article = Factory(:article, :channel => @channel)
      @category = Factory(:category, :channel => @channel)
      @article.categories << @category
    
      get :index, :renders_with => 'tprojects', :parts => @category.slug
      response.should render_template('index')
      response.should contain("Template _tprojects_list.html.erb")
      assigns(:categories).should == [@category]
    end
  
    it "should render item template if article slug exists" do
      @channel = Factory(:channel, :name => 'TProjects', :slug => 'tprojects')
      @article = Factory(:article, :channel => @channel)
      
      get :index, :renders_with => 'tprojects', :parts => @article.slug
      response.should render_template('article_by_slug')
      response.should contain("Template _tprojects_item.html.erb")      
    end
  
    it "should render item template if article slug present and category slug present" do
      @channel = Factory(:channel, :name => 'TProjects', :slug => 'tprojects')
      @article = Factory(:article, :channel => @channel)
      @category = Factory(:category, :channel => @channel)
      @article.categories << @category
      
      get :index, :renders_with => 'tprojects', :parts => [@category.slug, @article.slug]
      response.should render_template('article_by_slug')
      response.should contain("Template _tprojects_item.html.erb")
    end
    
  end
  
end