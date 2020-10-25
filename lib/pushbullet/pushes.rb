module Pushbullet
  module Pushes
    def pushes(params: {}, cursor: nil)
      params = process_cursor(cursor, params: params)
      path = 'pushes'
      authorise_and_send(http_method: :get, path: path, params: params)
    end

    def self_pushes(params: {}, cursor: nil)
      params = process_cursor(cursor, params: params.merge({ self: true }))

      path = 'pushes'
      authorise_and_send(http_method: :get, path: path, params: params)
    end
  end
end
