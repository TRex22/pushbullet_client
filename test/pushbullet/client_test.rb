require "test_helper"

class PushbulletTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Pushbullet::VERSION
  end

  def test_that_the_client_has_compatible_api_version
    assert_equal 'v2', Pushbullet::Client.compatible_api_version
  end

  def test_that_the_client_has_api_version
    assert_equal 'v2 2020-10-17', Pushbullet::Client.api_version
  end
end
