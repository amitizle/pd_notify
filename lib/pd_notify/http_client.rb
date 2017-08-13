require 'rest-client'
require 'json'
require 'uri'

module PdNotify
  class HTTPClient
    DEFAULT_BASE_URL = 'https://api.pagerduty.com'
    def initialize
      headers = prepare_headers
      base_url = Utils::Config.instance.get('base_url') || Utils::Config.instance.default('base_url')
      @site = RestClient::Resource.new(base_url, headers: headers)
    end

    # opts:
    #   query_params - expected to be an array of arrays, each
    #                  sub array contains two items, key=val ([key, val])
    def get(path, opts = {})
      begin
        if opts[:query_params]
          uri = URI(path)
          uri.query = opts[:query_params].map {|qp| "#{qp.first}=#{qp.last}"}.join('&')
          path = uri.to_s
        end
        response = @site[path].get
        JSON.parse(response.body)
        # TODO catch specific exceptions
      rescue RestClient::Unauthorized => e
        raise # TODO
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body) rescue {}
      rescue Exception => e
        raise
      end
    end

    private

    def prepare_headers
      token = Utils::Config.instance.get('api_key')
      if !token
        raise ArgumentError, 'api_key was not found in the configuration'
      end
      {
        'Accept' => 'application/vnd.pagerduty+json;version=2',
        'Authorization' => "Token token=#{token}"
      }
    end
  end
end
