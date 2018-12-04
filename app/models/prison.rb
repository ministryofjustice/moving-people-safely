# frozen_string_literal: true

class Prison < Establishment
  default_scope lambda {
    today = Date.today
    today_ymd = today.strftime('%Y-%m-%d')
    today_ym  = today.strftime('%Y-%m')
    today_y   = today.strftime('%Y')

    where(
      '(end_date IS NULL) OR ' \
      '(LENGTH(end_date) = 10 AND end_date >= ?) OR ' \
      '(LENGTH(end_date) = 7 AND end_date >= ?) OR ' \
      '(LENGTH(end_date) = 4 AND end_date >= ?)', today_ymd, today_ym, today_y
    )
  }
end
