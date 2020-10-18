module Pushbullet
  module Texts
    def texts
      path = 'texts'
      authorise_and_send(http_method: :get, path: path)
    end
  end
end
