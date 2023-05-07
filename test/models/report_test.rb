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

  test 'should not edit another report' do
    report = reports(:report1)
    assert_not report.editable?(users(:user2))
  end

  test 'should edit own report' do
    report = reports(:report1)
    assert report.editable?(users(:user1))
  end

  test 'should get only date' do
    report = reports(:report1)
    p report.created_at
    assert_equal report.created_at.to_date, report.created_on
  end
end
