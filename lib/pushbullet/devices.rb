module Pushbullet
  module Devices
    def devices(params: {}, cursor: nil)
      params = process_cursor(cursor, params: params)
      path = 'devices'
      authorise_and_send(http_method: :get, path: path, params: params)
    end
  end
end
