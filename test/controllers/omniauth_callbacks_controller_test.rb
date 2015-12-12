require 'test_helper'

class OmniauthCallbacksControllerTest < ActionController::TestCase
  test "should get instagram" do
    get :instagram
    assert_response :success
  end

end
