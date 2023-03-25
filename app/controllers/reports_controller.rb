# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]
  before_action :check_report_links, only: %i[update]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @mentioning_reports = @report.mentioned_reports
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      added_report_ids = @mentioned_report_ids - @report.mentioning_reports.map(&:id)
      deleted_report_ids = @report.mentioning_reports.map(&:id) - @mentioned_report_ids

      added_report_ids.each do |id|
        Mention.create(mentioning_id: @report.id, mentioned_id: id)
      end
      deleted_report_ids.each do |id|
        Mention.find_by(mentioning_id: @report.id, mentioned_id: id).destroy
      end
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

  def check_report_links
    domain = "http://localhost:3000/reports/"
    content = report_params[:content]
    @mentioned_report_ids = content.scan(/#{domain}[0-9]+/)
                        .map { |url| url.split('/')[-1].to_i }
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
