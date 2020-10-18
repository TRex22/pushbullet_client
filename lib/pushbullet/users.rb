module Pushbullet
  module Users
    def me
      path = 'users/me'
      authorise_and_send(http_method: :get, path: path)
    end
  end
end
