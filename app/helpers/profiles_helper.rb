module ProfilesHelper
  def acct_status_image(acct_status)
    return 'open_acct' if acct_status == 'open'
    'not_open_acct'
  end
end
