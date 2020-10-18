module Pushbullet
  module Subscriptions
    def subscriptions
      path = 'subscriptions'
      authorise_and_send(http_method: :get, path: path)
    end
  end
end
