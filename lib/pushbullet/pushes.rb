module Pushbullet
  module Pushes
    # modified_after: Unix timestamp (use the newest `modified` you have stored). Only pushes
    #   modified since then are returned, which costs far fewer rate limit units than
    #   re-reading everything.
    # active: true to leave out deleted pushes (useful for a first full fetch).
    def pushes(params: {}, cursor: nil, modified_after: nil, active: nil)
      params = params.dup
      params['modified_after'] = modified_after unless modified_after.nil?
      params['active'] = active unless active.nil?
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
