require File.dirname(__FILE__) + '/../spec_helper'

describe Channel do

  it "should default to a public channel" do
    Channel.create(:name => 'Blog').is_public.should be_true
  end

end