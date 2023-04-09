# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.exec_transaction
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      registered_report_ids = @report.mentioning_reports.map(&:id)
      ids = @report.mentioning_report_ids

      added_report_ids = ids - registered_report_ids
      deleted_report_ids = registered_report_ids - ids

      add_mentioning_reports(added_report_ids)
      delete_mentioning_reports(deleted_report_ids)

      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def add_mentioning_reports(added_report_ids)
    added_report_ids.each do |id|
      Mention.create(mentioning_id: @report.id, mentioned_id: id)
    end
  end

  def delete_mentioning_reports(deleted_report_ids)
    deleted_report_ids.each do |id|
      Mention.find_by(mentioning_id: @report.id, mentioned_id: id).destroy
    end
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
