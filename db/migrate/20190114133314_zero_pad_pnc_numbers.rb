class ZeroPadPncNumbers < ActiveRecord::Migration[5.2]
  # E.g. PNC number '90/123A' becomes '90/0000123A'
  def up
    detainees = Detainee.joins(escort: [move: :from_establishment]).where(
      '(LENGTH(detainees.pnc_number) < 11 OR LENGTH(escorts.pnc_number) < 11) ' +
      "AND establishments.type = 'PoliceCustody'"
    )

    detainees.each do |detainee|
      padded = Detainee.standardise_pnc(detainee.pnc_number)
      escort = detainee.escort
      say "Updating escort #{escort.id} PNC number (detainee:#{detainee.pnc_number}, escort:#{escort.pnc_number}) to #{padded}."
      detainee.update_column(:pnc_number, padded)
      escort.update_column(:pnc_number, padded)
    end
  end

  def down
  end
end
