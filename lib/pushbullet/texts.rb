module Pushbullet
  module Texts
    def texts(params: {}, cursor: nil)
      params = process_cursor(cursor, params: params)
      path = 'texts'
      authorise_and_send(http_method: :get, path: path, params: params)
    end
  end
end
