# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should show email without name' do
    user = users(:user1)
    assert_equal user.email, user.name_or_email
  end

  test 'should show name with name' do
    user = users(:user2)
    assert_equal user.name, user.name_or_email
  end
end
