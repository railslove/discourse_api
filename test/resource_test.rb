require 'discourse_api'
require 'minitest/autorun'
require 'minitest/pride'

class ResourceTest < Minitest::Test
  class TestClient < DiscourseApi::Resource
    post :test_post => "/hello/:world", :require => [:foo]
    put :test_put => "/users/:username.json", :require => [:username]
  end

  def test_methods_exists
    assert_respond_to(TestClient.new, :test_post)
    assert_respond_to(TestClient.new, :test_put)
  end

  def test_api_args
    client = TestClient.new
    client.api_key = "XXX"
    client.api_username = "BOB"
    assert_equal({:api_key => "XXX", :api_username => "BOB", :a => 1}, client.api_args({:a => 1}))
  end

end
