module Pushbullet
  module Permanents
    # See: https://stackoverflow.com/questions/38027963/pushbullet-api-thread-id-to-conversation-iden-for-sms
    def permanents(device_identity:, params: {}, cursor: nil)
      params = process_cursor(cursor, params: params)

      path = "permanents/#{device_identity}_threads"
      authorise_and_send(http_method: :get, path: path, params: params)
    end

    def permanent_conversation(device_identity:, thread_id:, params: {}, cursor: nil)
      params = process_cursor(cursor, params: params)

      path = "permanents/#{device_identity}_thread_#{thread_id}"
      authorise_and_send(http_method: :get, path: path, params: params)
    end
  end
end
