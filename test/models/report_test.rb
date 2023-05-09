# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    user = users(:user1)
    @report1 = reports(:report1)
    @report2 = reports(:report2)

    title = 'TITLE'
    content = <<~TEXT
      http://localhost:3000/reports/#{@report1.id}
      http://localhost:3000/reports/#{@report2.id}
    TEXT

    @report = user.reports.build(title:, content:)
  end

  test 'should not save report without title' do
    @report.title = ''
    assert_not @report.save
  end

  test 'should not save report without content' do
    @report.content = ''
    assert_not @report.save
  end

  test 'should save report with title and content and mention reports' do
    assert @report.save
    assert [], @report.mentioning_reports.map(&:id) - [@report1.id, @report2.id]
  end

  test 'should not mention the same report' do
    report3 = reports(:report3)
    @report.content += <<TEXT
      http://localhost:3000/reports/#{@report1.id}
      http://localhost:3000/reports/#{@report2.id}
      http://localhost:3000/reports/#{report3.id}
TEXT

    @report.save
    assert_equal [], @report.mentioning_reports.map(&:id) - [@report1.id, @report2.id, report3.id]
  end

  test 'should not mention own report' do
    new_content = <<TEXT
      http://localhost:3000/reports/#{@report1.id}
      http://localhost:3000/reports/#{@report2.id}
TEXT
    @report1.update(content: new_content)
    assert_equal [@report2.id], @report1.mentioning_reports.map(&:id)
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
