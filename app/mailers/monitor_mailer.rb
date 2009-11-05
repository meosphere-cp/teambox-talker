class MonitorMailer < ActionMailer::Base
  include GmailSmtpSettings
  
  def signup(account, user)
    from        "\"Talker Notifier\" <notifier@talkerapp.com>"
    recipients  "info@talkerapp.com"
    subject     "New account: #{account.subdomain}"
    body        :account => account, :user => user
  end
end
