module Pushbullet
  module Subscriptions
    def subscriptions(params: {}, cursor: nil)
      params = process_cursor(cursor, params: params)
      path = 'subscriptions'
      authorise_and_send(http_method: :get, path: path, params: params)
    end
  end
end
