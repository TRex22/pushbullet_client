module Pushbullet
  module Permanents
    # See: https://stackoverflow.com/questions/38027963/pushbullet-api-thread-id-to-conversation-iden-for-sms
    def permanents(device_identity:, params: {}, cursor: nil)
      permanents_request("permanents/#{device_identity}_threads", params, cursor)
    end

    def permanent_conversation(device_identity:, thread_id:, params: {}, cursor: nil)
      permanents_request("permanents/#{device_identity}_thread_#{thread_id}", params, cursor)
    end

    private

    # The permanents endpoints must not be sent a page limit. The flag is always reset,
    # including when the request raises or the API returns an error, so a failed call
    # cannot leave every later request without a limit.
    def permanents_request(path, params, cursor)
      @disable_limit = true
      params = process_cursor(cursor, params: params)

      authorise_and_send(http_method: :get, path: path, params: params)
    ensure
      @disable_limit = false
    end
  end
end
