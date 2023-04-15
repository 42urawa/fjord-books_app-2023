# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :active_mentions, class_name: 'Mention', inverse_of: :mentioning, foreign_key: :mentioning_id, dependent: :destroy
  has_many :passive_mentions, class_name: 'Mention', inverse_of: :mentioned, foreign_key: :mentioned_id, dependent: :destroy
  has_many :mentioning_reports, through: :active_mentions, source: :mentioned
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true

  REPORT_URL_REGEXP = %r{http://localhost:3000/reports/\d+}

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def mentioning_report_ids
    content.scan(REPORT_URL_REGEXP)
           .map { |url| url.split('/')[-1].to_i }
           .uniq
  end

  def exec_create_transaction
    success = true

    ApplicationRecord.transaction do
      success &= save
      mentioning_report_ids.each do |mentioning_report_id|
        success &= active_mentions.create(mentioned_id: mentioning_report_id)
      end
      raise ActiveRecord::Rollback unless success
    end

    success
  end

  def exec_update_transaction(report_params)
    success = true

    ApplicationRecord.transaction do
      success &= update(report_params)

      report_ids_in_content = mentioning_report_ids
      report_ids_in_db = mentioning_reports.map(&:id)

      inserted_report_ids = report_ids_in_content - report_ids_in_db
      deleted_report_ids = report_ids_in_db - report_ids_in_content

      inserted_report_ids.each do |inserted_report_id|
        success &= active_mentions.create(mentioned_id: inserted_report_id)
      end

      deleted_report_ids.each do |deleted_report_id|
        success &= active_mentions.find_by(mentioned_id: deleted_report_id).destroy
      end
      raise ActiveRecord::Rollback unless success
    end

    success
  end
end
