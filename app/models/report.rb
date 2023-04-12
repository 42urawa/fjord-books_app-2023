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

  DOMAIN = 'http://localhost:3000/reports/'

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def report_ids_in_content
    content.scan(/#{DOMAIN}[0-9]+/)
           .map { |url| url.split('/')[-1].to_i }
           .uniq
  end

  def exec_create_transaction
    success = true

    ApplicationRecord.transaction do
      success &= save
      report_ids_in_content.each do |report_id|
        success &= active_mentions.create(mentioned_id: report_id)
      end
      raise ActiveRecord::Rollback unless success
    end

    success
  end

  def exec_update_transaction(report_params)
    success = true

    ApplicationRecord.transaction do
      success &= update(report_params)

      inserted_report_ids = report_ids_in_content - mentioning_reports.map(&:id)
      deleted_report_ids = mentioning_reports.map(&:id) - report_ids_in_content

      inserted_report_ids.each do |report_id|
        success &= active_mentions.create(mentioned_id: report_id)
      end

      deleted_report_ids.each do |report_id|
        success &= active_mentions.find_by(mentioned_id: report_id).destroy
      end
      raise ActiveRecord::Rollback unless success
    end

    success
  end
end
