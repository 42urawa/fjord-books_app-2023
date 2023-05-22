# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @user = FactoryBot.create(:user)
    @report1 = FactoryBot.create(:report)
    @report2 = FactoryBot.create(:report)
  end

  test 'should not save report without title' do
    # user = FactoryBot.create(:user)
    report = FactoryBot.build(:report, title: '', user: @user)
    assert_not report.save
  end

  test 'should not save report without content' do
    report = FactoryBot.build(:report, content: '', user: @user)
    assert_not report.save
  end

  test 'should save report with title and content' do
    report = FactoryBot.build(:report, user: @user)
    assert report.save
  end

  test 'should get mentioning reports' do
    content = <<~TEXT
      http://localhost:3000/reports/#{@report1.id}
      http://localhost:3000/reports/#{@report2.id}
    TEXT

    report = FactoryBot.create(:report, user: @user, content:)
    assert_equal [], report.mentioning_reports.map(&:id) - [@report1.id, @report2.id]
  end

  test 'should not mention the duplicate report' do
    content = <<~TEXT
      http://localhost:3000/reports/#{@report1.id}
      http://localhost:3000/reports/#{@report2.id}
      http://localhost:3000/reports/#{@report2.id}
    TEXT

    report = FactoryBot.create(:report, user: @user, content:)
    assert_equal [], report.mentioning_reports.map(&:id) - [@report1.id, @report2.id]
  end

  test 'should not mention self report' do
    new_content = <<TEXT
      http://localhost:3000/reports/#{@report1.id}
      http://localhost:3000/reports/#{@report2.id}
TEXT
    @report1.update(content: new_content)
    assert_equal [@report2.id], @report1.mentioning_reports.map(&:id)
  end

  test 'should not edit another report' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    report = FactoryBot.create(:report, user: user1)
    assert_not report.editable?(user2)
  end

  test 'should edit own report' do
    report = FactoryBot.create(:report)
    assert report.editable?(report.user)
  end

  test 'should get only date' do
    report = FactoryBot.create(:report, created_at: '2023-05-22 12:34:56')
    assert_equal Date.new(2023, 5, 22), report.created_on
  end
end
