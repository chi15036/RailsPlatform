require 'test_helper'

class EntityControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get entity_index_url
    assert_response :success
  end

end
