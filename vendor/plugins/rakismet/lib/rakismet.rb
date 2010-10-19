require 'net/http'
require 'uri'
require 'yaml'

require 'rakismet/model'
require 'rakismet/filter'
require 'rakismet/controller'

module Rakismet
  def self.version
    @version ||= begin
      version = YAML.load_file(File.join(File.dirname(__FILE__), %w(.. VERSION.yml)))
      [version[:major], version[:minor], version[:patch]].join('.')
    end
  end

  class Base
    cattr_accessor :valid_key, :current_request
    
    class << self
      def validate_key
        validate_constants
        akismet = URI.parse(verify_url)
        _, valid = Net::HTTP.start(akismet.host) do |http|
          data = "key=#{Rakismet::KEY}&blog=#{Rakismet::URL}"
          http.post(akismet.path, data, Rakismet::HEADERS)
        end
        self.valid_key = (valid == 'valid')
      end
      
      def valid_key?
        @@valid_key == true
      end
      
      def akismet_call(function, args={})
        validate_constants
        args.merge!(:blog => Rakismet::URL)
        akismet = URI.parse(call_url(function))
        _, response = Net::HTTP.start(akismet.host) do |http|
          data = args.map { |k,v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
          http.post(akismet.path, data, Rakismet::HEADERS)
        end
        response
      end
      
      protected
        
        def verify_url
          "http://#{Rakismet::HOST}/1.1/verify-key"
        end

        def call_url(function)
          "http://#{Rakismet::KEY}.#{Rakismet::HOST}/1.1/#{function}"
        end

        def validate_constants
          raise Undefined, "Rakismet::KEY is not defined"  if Rakismet::KEY.blank?
          raise Undefined, "Rakismet::URL is not defined"  if Rakismet::URL.blank?
          raise Undefined, "Rakismet::HOST is not defined" if Rakismet::HOST.blank?
        end
    end
  end
  
  Undefined = Class.new(NameError)
  
  HEADERS = {
    'User-Agent' => "Rails/#{Rails::VERSION::STRING} | Rakismet/#{Rakismet.version}",
    'Content-Type' => 'application/x-www-form-urlencoded'
  }
end
