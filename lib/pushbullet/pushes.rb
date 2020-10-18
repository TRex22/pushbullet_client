module Pushbullet
  module Pushes
    def pushes
      path = 'pushes'
      authorise_and_send(http_method: :get, path: path)
    end
  end
end
