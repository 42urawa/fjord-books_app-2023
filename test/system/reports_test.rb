# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  def setup
    user1 = users(:user1)
    sign_in(user1)
  end

  # test 'login' do
  #   setup
  #   assert_selector 'h1', text: '本の一覧'
  # end

  test 'create new report' do
    setup
    visit reports_path
    click_on '日報の新規作成'
    fill_in 'report_title', with: '今日の天気'
    fill_in 'report_content', with: '今日は雨だった'
    click_on '登録する'
    assert_selector 'h1', text: '日報の詳細'
    assert_selector 'p', text: '今日の天気'
    assert_selector 'p', text: '今日は雨だった'
    assert_selector 'p', text: '日報が作成されました。'
  end

  test 'update report' do
    setup
    visit "/reports/#{reports(:report1).id}/edit"
    fill_in 'report_title', with: 'タイトルを更新'
    fill_in 'report_content', with: '内容を更新'
    click_on '更新する'
    assert_selector 'h1', text: '日報の詳細'
    assert_selector 'p', text: 'タイトルを更新'
    assert_selector 'p', text: '内容を更新'
    assert_selector 'p', text: '日報が更新されました。'
  end

  test 'delete report' do
    setup
    visit "/reports/#{reports(:report1).id}/"
    assert_selector 'h1', text: '日報の詳細'
    click_on 'この日報を削除'
    assert_selector 'h1', text: '日報の一覧'
    assert_selector 'p', text: '日報が削除されました。'
  end
end
