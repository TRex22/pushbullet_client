module Pushbullet
  class Client
    include ::Pushbullet::Constants

    # Endpoints

    # TODO: Cleanup modules
    # TODO: Pagination
    # TODO: Limits
    # TODO: Date parsing
    # TODO: Create api client creation library

    def me
      path = 'users/me'
      authorise_and_send(http_method: :get, path: path)
    end

    def devices
      path = 'devices'
      authorise_and_send(http_method: :get, path: path)
    end

    def pushes
      path = 'pushes'
      authorise_and_send(http_method: :get, path: path)
    end

    def chats
      path = 'chats'
      authorise_and_send(http_method: :get, path: path)
    end

    def subscriptions
      path = 'subscriptions'
      authorise_and_send(http_method: :get, path: path)
    end

    def texts
      path = 'texts'
      authorise_and_send(http_method: :get, path: path)
    end

    # See: https://stackoverflow.com/questions/38027963/pushbullet-api-thread-id-to-conversation-iden-for-sms
    def permanents(device_identity:)
      path = "permanents/#{device_identity}_threads"
      authorise_and_send(http_method: :get, path: path)
    end

    def permanent_conversation(device_identity:, thread_id:)
      path = "permanents/#{device_identity}_thread_#{thread_id}"
      authorise_and_send(http_method: :get, path: path)
    end

    attr_reader :key, :secret, :base_path, :port

    def initialize(access_token:, base_path: 'https://api.pushbullet.com/v2', port: 80)
      @access_token = access_token
      @base_path = base_path
      @port = port
    end

    def self.compatible_api_version
      'v2'
    end

    # This is the version of the API docs this client was built off-of
    def self.api_version
      'v2 2020-10-17'
    end

    private

    def authorise_and_send(http_method:, path:, payload: {}, params: {})
      start_time = get_micro_second_time

      response = HTTParty.send(
        http_method.to_sym,
        construct_base_path(path, params),
        body: payload,
        headers: {
          'Access-Token': @access_token,
          'Content-Type': 'application/json'
        },
        port: port,
        format: :json
      )

      end_time = get_micro_second_time
      construct_response_object(response, path, start_time, end_time)
    end

    def construct_response_object(response, path, start_time, end_time)
      {
        'body' => parse_body(response, path),
        'headers' => response.headers,
        'metadata' => construct_metadata(response, start_time, end_time)
      }
    end

    def construct_metadata(response, start_time, end_time)
      total_time = end_time - start_time

      {
        'start_time' => start_time,
        'end_time' => end_time,
        'total_time' => total_time
      }
    end

    def body_is_present?(response)
      !body_is_missing?(response)
    end

    def body_is_missing?(response)
      response.body.nil? || response.body.empty?
    end

    def parse_body(response, path)
      parsed_response = JSON.parse(response.body) # Purposely not using HTTParty

      if parsed_response.dig(path.to_s)
        parsed_response.dig(path.to_s)
      else
        parsed_response
      end
    rescue JSON::ParserError => _e
      response.body
    end

    def get_micro_second_time
      (Time.now.to_f * 1000000).to_i
    end

    def construct_base_path(path, params)
      constructed_path = "#{base_path}/#{path}"

      if params != {}
        constructed_path
      else
        "#{constructed_path}?#{process_params(params)}"
      end
    end

    def process_params(params)
      params.keys.map { |key| "#{key}=#{params[key]}" }.join('&')
    end
  end
end
