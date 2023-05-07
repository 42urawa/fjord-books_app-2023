# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @report = @user.reports.build(title: 'title1', content: 'content1')
  end

  test 'should not save report without title' do
    @report.title = ''
    assert_not @report.save
  end

  test 'should not save report without content' do
    @report.content = ''
    assert_not @report.save
  end

  test 'should save report with title and content' do
    assert @report.save
  end
end
