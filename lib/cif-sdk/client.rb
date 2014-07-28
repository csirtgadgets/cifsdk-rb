require 'json'
require 'httpclient'
require 'uri'
require 'pp'

module CIF
  module SDK
    class Client
      attr_accessor :remote, :token, :verify_ssl, :log, :handle,
      :query, :submit, :logger, :config_path, :columns, :submission, :search_id
      def initialize params = {}
        params.each { |key, value| send "#{key}=", value }
        @handle = HTTPClient.new(:agent_name => 'rb-cif-sdk/0.0.1')
        unless @verify_ssl
          @handle.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end

      def _make_request(uri='',type='get',params={})
        params['token'] = @token
        case type
        when 'get'
          self.logger.debug { "uri: #{uri}" }
          uri = URI(@remote + uri)
          res = @handle.get(uri,params)
        when 'post'
          uri = URI(@remote + '/?token=' + @token.to_s)
          self.logger.debug { "uri: #{uri}.to_s" }
          res = @handle.post(uri,params['data'])
        end

        case res.status_code
        when 200...299
          return JSON.parse(res.body)
        when 300...399
          @logger.debug { "received: #{res.status_code}" }
        when 400
            @logger.warn { 'unauthorized, bad or missing token' }
        when 404
            @logger.warn { 'invalid remote uri: #{uri}.to_s' }
        when 500...600
          @logger.fatal { 'router failure, contact administrator' }
        end
        return nil

      end

      def ping
        start = Time.now()

        rv = self._make_request(uri='/ping')
        return nil unless(rv)

        return (Time.now()-start)
      end
      
      def search_id(args)
        params = {
          :id  => args['search_id'],
        }
        
        res = self._make_request(uri='/observables',type='get',params=params)
        return nil unless(res)
        return res
      end

      def search_cc(args)
        q = args['query']

        params = {
            q   => q,
        }

        res = self._make_request(uri="/countries",type='get',params=params)
        return nil unless(res)
        return res
      end

      def search(args)
        q = args['query'] || begin
          self.logger.fatal { 'missing param: query '}
          return nil
        end

        nlog = false
        unless @log == nil
          nlog = true
        end
        params = {
          'nolog' => nlog,
          'q'     => q,
        }

        res = self._make_request(uri="/observables",type='get',params=params)
        return nil unless(res)
        return res

      end

      def submit(data=nil)
        #  '{"observable":"example.com","confidence":"50",":tlp":"amber",
        #  "provider":"me.com","tags":["zeus","botnet"]}'
        #data = JSON.generate(data) if data.is_a?(::Hash)
        params = {
          'data' => data
        }
        res = self._make_request(uri='',type='post',params)
        return nil unless(res)
        return res
      end
    end
  end
end
