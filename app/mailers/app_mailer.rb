class AppMailer < ActionMailer::Base
  default from: "info@myflix.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.app_mailer.send_welcome_email.subject
  #
  def send_welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to Myflix!"
  end
end
