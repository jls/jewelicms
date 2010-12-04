require File.dirname(__FILE__) + '/../spec_helper'

describe Article do
  
  it "should be invalid without a title" do
    @article = Factory.build(:article, :title => nil)
    @article.valid?.should be_false
  end
  
  it "should be invalid without a channel" do
    @article = Factory.build(:article, :channel_id => nil)
    @article.valid?.should be_false
  end
  
  context :value_for_method do 
    
    before(:each) do
      @channel = Factory(:channel)
      @text_type = Factory(:data_field_type)
      @data_fields = [
          Factory(:data_field, :channel => @channel, :label => 'Summary'),
          Factory(:data_field, :channel => @channel, :label => 'Body')
        ]
      @article = Factory(:article, :channel => @channel)
      Factory(:data_value, :article => @article, :data_field => @data_fields[0], :data_value => 'This is the example summary')
      Factory(:data_value, :article => @article, :data_field => @data_fields[1], :data_value => 'This is the example body')
    end
    
    it "should return nil for fields not set" do
      @article.data_values.first.update_attribute(:data_value, nil)
      @article.value_for(@article.data_values.first.data_field.label).should be_nil
    end
    
    it "should apply the data value filter by default" do
      @article.value_for('Summary').chomp.should == '<p>This is the example summary</p>'
    end
    
    it "should not apply the filter if filtering is turned off" do
      @article.value_for('Summary', false).should == 'This is the example summary'
    end
    
    it "should use the value cache after the first call" do
      original_summary = @article.value_for('Summary')
      @article.values_cache['Summary_true'] = 'Changed!'
      @article.value_for('Summary').should == 'Changed!'
    end
    
  end
  
  context :get_method do
    
    before(:each) do
      @user = Factory(:user)
      
      @blog_channel = Factory(:channel, :name => 'Blog', :slug => 'blog')
      @rand_channel = Factory(:channel, :name => 'Random', :slug => 'random')
      
      @blog_general_category = Factory(:category, :name => 'gen', :slug => 'gen', :channel => @blog_channel)
      @blog_dev_category = Factory(:category, :name => 'dev', :slug => 'dev', :channel => @blog_channel)
      
      @rand_funny_category = Factory(:category, :name => 'Funny', :slug => 'funny', :channel => @rand_channel)
      @rand_video_category = Factory(:category, :name => 'Video', :slug => 'video', :channel => @rand_channel)
      
      # Generate 5 articles for the blog channel that are in the general category
      # and 3 articles that are in the dev channel
      8.times do |n|
        article = Factory(:article, :channel => @blog_channel, :author => @user, :is_published => (n != 7))
        article.categories << ((n < 5) ? @blog_general_category : @blog_dev_category)
      end
      
      5.times do |n|
        article = Factory(:article, :channel => @rand_channel, :author => @user)
        article.categories << ((n < 3) ? @rand_funny_category : @rand_video_category)
      end
      
    end
    
    it "should be setup with two channels with two categories with 5 articles" do
      @rand_channel.categories.count.should == 2
      @blog_channel.categories.count.should == 2
      
      @blog_general_category.articles.count.should == 5
      
    end
    
    it "should return only published articles by default" do
      Article.get.count.should == 12
    end
    
    it "should return only article in channel when specified" do
      Article.get(:channel => @blog_channel.slug).count.should == 7
    end
    
    it "should return articles in multiple channels when specified" do
      Article.get(:channel => [@blog_channel.slug, @rand_channel.slug]).count.should == 12
    end
    
    it "should paginate if specified" do
      Article.get(:per_page => 3, :page => 1).count.should == 3
    end
    
    it "should default to descending order" do
      Article.get.first.created_at.should > Article.get.last.created_at
    end
    
    it "should return only articles in a single category when specified" do
      Article.get(:category => @blog_general_category.slug).count.should == 5
      @blog_general_category.articles.reverse.should == Article.get(:category => @blog_general_category.slug)
    end
    
    it "should return articles for multiple categories when specified" do
      Article.get(:category => [@blog_general_category.slug, @blog_dev_category.slug]).count.should == 7
    end
    
    it "should return articles for a given slug" do
      @first_article = Article.first
      Article.get(:slug => @first_article.slug).first.should == @first_article
    end
    
    it "should return unpublished articles when requested" do
      Article.get(:published => false).count.should == 1
    end
    
    it "should obey requested limit" do
      Article.get(:limit => 1).count.should == 1
    end
    
  end
  
end