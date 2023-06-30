require "test_helper"

class CreditPacksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get credit_packs_index_url
    assert_response :success
  end
end
