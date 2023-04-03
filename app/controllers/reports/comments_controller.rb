# frozen_string_literal: true

class Reports::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = @report = Report.find(params[:report_id])
    @create_error_path = 'reports/show'
  end
end
