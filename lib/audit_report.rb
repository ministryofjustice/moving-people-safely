# frozen_string_literal: true

require 'csv'

class AuditReport
  def initialize(escort_id)
    @escort_id = escort_id
  end

  def call
    puts COLUMNS.to_csv

    Escort.find(@escort_id).audits.order(:created_at).each do |audit|
      puts extract_data(audit).to_csv
    end
  end

  private

  COLUMNS = %w[
    escort_id
    escort_number
    detainee_surname
    detainee_forenames
    move_date
    move_from
    move_to
    user
    user_email
    time_of_action
    action
  ].freeze

  def extract_data(audit)
    escort_data(audit) + user_data(audit) + action_data(audit)
  end

  def escort_data(audit)
    [
      audit.escort_id,
      audit.escort.number,
      audit.escort.detainee_surname,
      audit.escort.detainee_forenames,
      audit.escort.move_date.strftime('%F'),
      audit.escort.move_from_establishment.name,
      audit.escort.move.to
    ]
  end

  def user_data(audit)
    [
      audit.user.full_name,
      audit.user.email
    ]
  end

  def action_data(audit)
    [
      audit.created_at.iso8601,
      audit.action
    ]
  end
end
