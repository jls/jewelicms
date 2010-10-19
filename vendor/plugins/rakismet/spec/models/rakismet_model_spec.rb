require File.dirname(__FILE__) + '/../spec_helper'
require 'ostruct'

class AkismetModel
  include Rakismet::Model
end

class StoredParams
  include Rakismet::Model
  attr_accessor :user_ip, :user_agent, :referrer
end

describe AkismetModel do

  before do
    @model = AkismetModel.new
    comment_attrs.each_pair { |k,v| @model.stub!(k).and_return(v) }
  end
  
  it "should have default mappings" do
    [:comment_type, :author, :author_email, :author_url, :content].each do |field|
      fieldname = field.to_s =~ %r(^comment_) ? field : "comment_#{field}".intern
      AkismetModel.akismet_attrs[fieldname].should eql(field)
     end
  end
  
  it "should have nil placeholders for optional binding variables" do
    [:user_ip, :user_agent, :referrer].each do |field|
      AkismetModel.akismet_attrs.should have_key(field)
     end
  end

  mapped_params = { :comment_type => :type2, :author => :author2, :content => :content2,
                    :author_email => :author_email2, :author_url => :author_url2 }
    
  describe override = AkismetModel.subclass('Override') { rakismet_attrs(mapped_params.dup) } do
    it "should override default mappings" do
      [:comment_type, :author, :author_url, :author_email, :content].each do |field|
        fieldname = field.to_s =~ %r(^comment_) ? field : "comment_#{field}".intern
         override.akismet_attrs[fieldname].should eql(mapped_params[field])
       end
    end
  end

  extended_params = { :user_ip => :stored_ip, :user_agent => :stored_agent,
                      :referrer => :stored_referrer }

  describe extended = AkismetModel.subclass('Extended') { rakismet_attrs(extended_params.dup) } do
    
    before do
      @extended = extended.new
      attrs = comment_attrs(:stored_ip => '127.0.0.1', :stored_agent => 'RSpec', :stored_referrer => 'http://test.host/')
      attrs.each_pair { |k,v| @extended.stub!(k).and_return(v) }
    end
    
    it "should extend optional mappings" do
      [:user_ip, :user_agent, :referrer].each do |field|
        extended.akismet_attrs[field].should eql(extended_params[field])
      end
    end
    
    describe ".spam!" do
      it "should use stored request vars if available" do
        Rakismet::Base.should_receive(:akismet_call).
          with('submit-spam', akismet_attrs(:user_ip => '127.0.0.1', :user_agent => 'RSpec',
                                            :referrer => 'http://test.host/'))
        @extended.spam!
      end
    end
    
    describe ".ham!" do
      it "should use stored request vars if available" do
        Rakismet::Base.should_receive(:akismet_call).
          with('submit-ham', akismet_attrs(:user_ip => '127.0.0.1', :user_agent => 'RSpec',
                                            :referrer => 'http://test.host/'))
        @extended.ham!
      end
    end
  end

  @proc = proc { author.reverse }
  block_params = { :author => @proc }

  describe block = AkismetModel.subclass('Block') { rakismet_attrs(block_params) } do

    before do
      @block = block.new
      comment_attrs.each_pair { |k,v| @block.stub!(k).and_return(v) }
    end

    it "should accept a block" do
      block.akismet_attrs[:author].should eql(@proc)
    end

    it "should eval block with self = instance" do
      data = @block.send(:akismet_data)
      data[:comment_author].should eql(comment_attrs[:author].reverse)
    end
  end

  extra_params = { :extra => :extra, :another => lambda { } }

  describe extra = AkismetModel.subclass('ExtraParams') { rakismet_attrs(extra_params.dup) } do
    it "should map additional attributes" do
      [:extra, :another].each do |field|
        extra.akismet_attrs[field].should eql(extra_params[field])
      end
    end
  end

  string_params = { :comment_type => 'pingback' }

  describe string = AkismetModel.subclass('StringParams') { rakismet_attrs(string_params) } do

    before do
      @string = string.new
      comment_attrs.each_pair { |k,v| @string.stub!(k).and_return(v) }
    end

    it "should map string attributes" do
      @string.send(:akismet_data)[:comment_type].should eql('pingback')
    end
  end

  describe ".spam?" do
    
    before do
      Rakismet::Base.current_request = request
    end
    
    it "should eval request variables in context of Base.rakismet_binding" do
      Rakismet::Base.should_receive(:akismet_call).
                with('comment-check', akismet_attrs.merge(:user_ip => '127.0.0.1', 
                                                          :user_agent => 'RSpec', 
                                                          :referrer => 'http://test.host/referrer'))
      @model.spam?
    end
    
    it "should cache result of #spam?" do
      Rakismet::Base.should_receive(:akismet_call).once
      @model.spam?
      @model.spam?
    end

    it "should be true if comment is spam" do
      Rakismet::Base.stub!(:akismet_call).and_return('true')
      @model.should be_spam
    end
    
    it "should be false if comment is not spam" do
      Rakismet::Base.stub!(:akismet_call).and_return('false')
      @model.should_not be_spam
    end
    
    it "should set last_akismet_response" do
      Rakismet::Base.stub!(:akismet_call).and_return('response')
      @model.spam?
      @model.akismet_response.should eql('response')
    end

    it "should not throw an error if request vars are missing" do
      Rakismet::Base.current_request = empty_request
      lambda { @model.spam? }.should_not raise_error(NoMethodError)
    end
  end
  
  describe StoredParams do
      before do
        Rakismet::Base.current_request = nil
        @model = StoredParams.new
        comment_attrs.each_pair { |k,v| @model.stub!(k).and_return(v) }
      end

    it "should use local values if Rakismet binding is not present" do
      @model.user_ip = '127.0.0.1'
      @model.user_agent = 'RSpec'
      @model.referrer = 'http://test.host/referrer'

      Rakismet::Base.should_receive(:akismet_call).
                with('comment-check', akismet_attrs.merge(:user_ip => '127.0.0.1',
                                                          :user_agent => 'RSpec',
                                                          :referrer => 'http://test.host/referrer'))
      @model.spam?
    end
  end

  describe ".spam!" do
    it "should call Base.akismet_call with submit-spam" do
      Rakismet::Base.should_receive(:akismet_call).with('submit-spam', akismet_attrs)
      @model.spam!
    end

    it "should mutate #spam?" do
      Rakismet::Base.stub!(:akismet_call)
      @model.instance_variable_set(:@_spam, false)
      @model.spam!
      @model.should be_spam
    end
  end

  describe ".ham!" do
    it "should call Base.akismet_call with submit-ham" do
      Rakismet::Base.should_receive(:akismet_call).with('submit-ham', akismet_attrs)
      @model.ham!
    end

    it "should mutate #spam?" do
      Rakismet::Base.stub!(:akismet_call)
      @model.instance_variable_set(:@_spam, true)
      @model.ham!
      @model.should_not be_spam
    end
  end
  
  private
  
    def comment_attrs(attrs={})
      { :comment_type => 'test', :author => 'Rails test',
        :author_email => 'test@test.host', :author_url => 'test.host',
        :content => 'comment content', :blog => Rakismet::URL }.merge(attrs)
    end
    
    def akismet_attrs(attrs={})
      { :comment_type => 'test', :comment_author_email => 'test@test.host',
        :comment_author => 'Rails test', :comment_author_url => 'test.host',
        :comment_content => 'comment content' }.merge(attrs)
    end
    
    def request
      OpenStruct.new(:remote_ip => '127.0.0.1',
                     :user_agent => 'RSpec',
                     :referer => 'http://test.host/referrer')
    end

    def empty_request
      OpenStruct.new(:remote_ip => nil,
                     :user_agent => nil,
                     :referer => nil)
    end

end