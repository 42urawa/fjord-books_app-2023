# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = FactoryBot.create(:user)
    sign_in(user)
  end

  test 'should get index' do
    get users_path
    assert_response :success
  end

  test 'should get show' do
    user = FactoryBot.create(:user)
    get user_path(user)
    assert_response :success
  end
end
