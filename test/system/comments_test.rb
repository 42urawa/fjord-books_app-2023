# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    sign_in(@user2)
    @report = FactoryBot.create(:report, user: @user1)
  end

  test 'should create new comment and delete only self comment' do
    visit report_path(@report)
    comment = 'ぴちぴちギャル'
    fill_in 'comment_content', with: comment
    click_on 'コメントする'
    assert_selector 'h1', text: '日報の詳細'
    assert_selector 'p', text: 'コメントが作成されました。'
    assert_selector 'li', text: comment
    assert_selector 'li', text: comment
    assert_button '削除'
    accept_confirm do
      click_on '削除'
    end
    assert_selector 'h1', text: '日報の詳細'
    assert_selector 'p', text: 'コメントが削除されました。'
  end
end
