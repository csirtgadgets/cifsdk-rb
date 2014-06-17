require 'json'
require 'httpclient'
require 'uri'
require 'pp'
require 'openssl'
require 'yaml'

module CIF
  module SDK
    class Client
      attr_accessor :remote, :token, :verify_ssl, :log, :handle, :logger, :config_path

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

        unless @token
          @logger.fatal { 'missing token' }
          return nil
        end

        uri = URI(@remote + uri)

        start = Time.now()

        res = @handle.get(uri,params)
        if res.status_code > 299
          @logger.debug { "received: #{res.status_code}" }
          if res.status_code == 400
            @logger.warn { 'unauthorized' }
          end
          return nil
        end

        return (Time.now()-start)
      end

      def search(args)
        pp args
      end

      def submit(args)

      end
    end
  end
end