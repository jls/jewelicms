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
  
end