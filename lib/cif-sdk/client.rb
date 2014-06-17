require 'json'
require 'httpclient'
require 'uri'
require 'pp'
require 'yaml'

module CIF
  module SDK
    class Client
      attr_accessor :remote, :token, :verify_ssl, :log, :handle,
      :query, :submit, :logger, :config_path, :columns, :submission
      def initialize params = {}
        params.each { |key, value| send "#{key}=", value }
        @handle = HTTPClient.new(:agent_name => 'rb-cif-sdk/0.0.1')
        unless @verify_ssl
          @handle.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end

      def ping
        uri = '/_ping'
        params = {
          :token => @token
        }

        uri = URI(@remote + uri)

        start = Time.now()

        res = @handle.get(uri,params)
        if res.status_code > 299
          @logger.debug { "received: #{res.status_code}" }
          if res.status_code == 400
            @logger.warn { 'unauthorized, bad or missing token' }
          end
          return nil
        end

        return (Time.now()-start)
      end

      def search(args)
        q = args['query'] || begin
          self.logger.fatal { 'missing param: query '}
          return nil
        end
        params = {
          :token  => @token,
        }
        uri = URI(@remote + '/' + q)
        res = @handle.get(uri,params)
        if res.status_code > 299
          @logger.debug { "received: #{res.status_code}" }
          if res.status_code == 400
            @logger.warn { 'unauthorized, bad or missing token' }
          elsif res.status_code >= 500
            @logger.fatal { 'router failure, contact administrator' }
          end
          return nil
        end
        return JSON.parse(res.body) # should always be an ARRAY

      end

      def submit(data=nil)
        #  '{"observable":"example.com","confidence":"50",":tlp":"amber",
        #  "provider":"me.com","tags":["zeus","botnet"]}'

        return nil if !data

        uri = URI(@remote + '/?token=' + @token.to_s)
        res = @handle.post(uri,data)
        if res.status_code > 299
          @logger.debug { "received: #{res.status_code}" }
          if res.status_code == 400
            @logger.warn { 'unauthorized, bad or missing token' }
          elsif res.status_code >= 500
            @logger.fatal { 'router failure, contact administrator' }
          end
          return nil
        end
        return JSON.parse(res.body)
      end
    end
  end
end