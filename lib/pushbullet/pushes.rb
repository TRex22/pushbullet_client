module Pushbullet
  module Pushes
    def pushes
      path = 'pushes'
      authorise_and_send(http_method: :get, path: path)
    end

    def self_pushes
      params = { self: true }
      path = 'pushes'
      authorise_and_send(http_method: :get, path: path, params: params)
    end
  end
end
