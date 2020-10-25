module Pushbullet
  module Users
    def me(params: {}, cursor: nil)
      params = process_cursor(cursor, params: params)
      path = 'users/me'
      authorise_and_send(http_method: :get, path: path, params: params)
    end
  end
end
