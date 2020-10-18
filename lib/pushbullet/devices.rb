module Pushbullet
  module Devices
    def devices
      path = 'devices'
      authorise_and_send(http_method: :get, path: path)
    end
  end
end
