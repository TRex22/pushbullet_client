module Pushbullet
  class Client
    include ::Pushbullet::Constants

    # Endpoints
    include ::Pushbullet::Chats
    include ::Pushbullet::Devices
    include ::Pushbullet::Permanents
    include ::Pushbullet::Pushes
    include ::Pushbullet::Subscriptions
    include ::Pushbullet::Texts
    include ::Pushbullet::Users

    # TODO: Add uploads
    # TODO: Add ephemerals
    # TODO: Websockets
    # TODO: Universal copy/paste
    # TODO: Encryption
    # TODO: Pagination
    # TODO: Limits
    # TODO: Date parsing
    # TODO: Create api client creation library

    attr_reader :key, :secret, :base_path, :port, :timeout
    attr_writer :base_path

    def initialize(access_token:, base_path: API_V2_BASE_PATH, port: 80, limit: 500, timeout: 1000)
      @access_token = access_token
      @base_path = base_path
      @port = port
      @limit = limit
      @disable_limit = false # Used internally for permanents calls
      @timeout = timeout
    end

    def self.compatible_api_version
      'v2'
    end

    # This is the version of the API docs this client was built off-of
    def self.api_version
      'v2 2024-02-23'
    end

    def check_api
      params = process_cursor(nil, params: {})
      path = ''
      authorise_and_send(http_method: :get, path: path, params: params, custom_base_path: API_BASE_PATH)
    end

    private

    def authorise_and_send(http_method:, path:, payload: {}, params: {}, custom_base_path: nil)
      start_time = micro_second_time_now

      if params.nil? || params.empty?
        params = {}
      end

      unless @disable_limit
        params['limit'] = @limit
      end

      begin
        response = send_request(http_method, path, params, payload, custom_base_path)
      rescue
        # Retry once
        # TODO: Add in retry amounts
        response = send_request(http_method, path, params, payload, custom_base_path)
      end

      end_time = micro_second_time_now
      construct_response_object(response, path, start_time, end_time)
    end

    def send_request(http_method, path, params, payload, custom_base_path)
      HTTParty.send(
        http_method.to_sym,
        construct_base_path(path, params, custom_base_path: custom_base_path),
        body: payload,
        headers: {
          'Access-Token': @access_token,
          'Content-Type': 'application/json'
        },
        port: port,
        format: :json,
        timeout: timeout
      )
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
        'total_time' => total_time,
        'cursor' => response.dig('cursor')
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

    def micro_second_time_now
      (Time.now.to_f * 1_000_000).to_i
    end

    def construct_base_path(path, params, custom_base_path: nil)
      if custom_base_path
        constructed_path = "#{custom_base_path}/#{path}"
      else
        constructed_path = "#{base_path}/#{path}"
      end

      if params == {}
        constructed_path
      else
        "#{constructed_path}?#{process_params(params)}"
      end
    end

    def process_params(params)
      params.keys.map { |key| "#{key}=#{params[key]}" }.join('&')
    end

    def process_cursor(cursor, params: {})
      unless cursor.nil? || cursor.empty?
        params['cursor'] = cursor
      end

      params
    end
  end
end
