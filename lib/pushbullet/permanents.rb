module Pushbullet
  module Permanents
    # See: https://stackoverflow.com/questions/38027963/pushbullet-api-thread-id-to-conversation-iden-for-sms
    def permanents(device_identity:, params: {}, cursor: nil)
      @disable_limit = true
      params = process_cursor(cursor, params: params)

      path = "permanents/#{device_identity}_threads"
      authorise_and_send(http_method: :get, path: path, params: params)
      @disable_limit = false
    end

    def permanent_conversation(device_identity:, thread_id:, params: {}, cursor: nil)
      @disable_limit = true
      params = process_cursor(cursor, params: params)

      path = "permanents/#{device_identity}_thread_#{thread_id}"
      authorise_and_send(http_method: :get, path: path, params: params)
      @disable_limit = false
    end
  end
end
