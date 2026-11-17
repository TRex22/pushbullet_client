require 'test_helper'

class PushbulletRateLimitTest < Minitest::Test
  def setup
    @client = Pushbullet::Client.new(access_token: 'token', limit: 250)
  end

  def test_response_includes_status_and_parsed_rate_limit
    stub_request(:get, %r{api.pushbullet.com/v2/pushes})
      .to_return(status: 200, body: '{"pushes":[]}',
                 headers: { 'X-Ratelimit-Limit' => '32768', 'X-Ratelimit-Remaining' => '32000',
                            'X-Ratelimit-Reset' => '1432447070' })

    response = @client.pushes

    assert_equal 200, response['status']
    assert_equal({ 'limit' => 32_768, 'remaining' => 32_000, 'reset' => 1_432_447_070 }, response['rate_limit'])
  end

  def test_rate_limit_values_are_nil_without_headers
    stub_request(:get, %r{api.pushbullet.com/v2/pushes}).to_return(status: 200, body: '{"pushes":[]}')

    assert_equal({ 'limit' => nil, 'remaining' => nil, 'reset' => nil }, @client.pushes['rate_limit'])
  end

  def test_a_429_is_reported_in_status
    stub_request(:get, %r{api.pushbullet.com/v2/pushes})
      .to_return(status: 429, body: '{"error":{"type":"invalid_request","code":"ratelimited"}}')

    assert_equal 429, @client.pushes['status']
  end

  def test_pushes_accepts_modified_after_and_active
    stub = stub_request(:get, %r{api.pushbullet.com/v2/pushes})
           .with(query: hash_including('modified_after' => '1700000000.5', 'active' => 'true', 'limit' => '250'))
           .to_return(status: 200, body: '{"pushes":[]}')

    @client.pushes(modified_after: 1_700_000_000.5, active: true)

    assert_requested stub
  end

  def test_pushes_does_not_mutate_the_given_params
    stub_request(:get, %r{api.pushbullet.com/v2/pushes}).to_return(status: 200, body: '{"pushes":[]}')
    params = {}

    @client.pushes(params: params, modified_after: 1)

    assert_empty params
  end

  def test_permanents_send_no_limit_and_always_restore_it
    stub = stub_request(:get, 'https://api.pushbullet.com/v2/permanents/dev_threads')
           .to_return(status: 200, body: '{"threads":[]}')

    @client.permanents(device_identity: 'dev')

    assert_requested stub # an exact URL with no query string: no limit parameter was sent
    refute @client.instance_variable_get(:@disable_limit)
  end

  def test_permanents_restore_the_limit_when_the_request_raises
    stub_request(:get, %r{permanents/dev_threads}).to_raise(Errno::ECONNRESET)

    assert_raises(Errno::ECONNRESET) { @client.permanents(device_identity: 'dev') }
    refute @client.instance_variable_get(:@disable_limit)
  end
end
