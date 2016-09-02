if LogStasher.enabled?
  LogStasher.watch('date_change') do |_name, start, finish, _id, payload, store|
    store[:new_date] = payload.fetch(:new_date, :error)

    duration = finish - start
    store[:duration] = duration if duration > 0
  end
end
