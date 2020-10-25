module Pushbullet
  module Chats
    def chats(params: {}, cursor: nil)
      params = process_cursor(cursor, params: params)
      path = 'chats'
      authorise_and_send(http_method: :get, path: path, params: params)
    end
  end
end
