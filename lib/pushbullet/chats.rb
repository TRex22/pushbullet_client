module Pushbullet
  module Chats
    def chats
      path = 'chats'
      authorise_and_send(http_method: :get, path: path)
    end
  end
end
