# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  test 'should not register without password having at least 6 characters' do
    visit root_path
    click_on 'アカウント登録'
    fill_in 'user_email', with: 'test1@example.com'
    fill_in 'user_password', with: 'passw'
    fill_in 'user_password_confirmation', with: 'passw'
    click_on 'アカウント登録'
    assert_selector 'div', text: 'パスワードは6文字以上で入力してください'
  end

  test 'should register with password having at least 6 characters' do
    visit root_path
    click_on 'アカウント登録'
    fill_in 'user_email', with: 'test1@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_on 'アカウント登録'
    assert_selector 'h1', text: '本の一覧'
    assert_selector 'p', text: 'アカウント登録が完了しました。'
  end
end
