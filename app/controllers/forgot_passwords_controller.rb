class ForgotPasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.generate_token
      AppMailer.delay.send_forgot_password(user)
      redirect_to confirm_forgot_password_path
    else
      flash[:error] = params[:email].blank? ? "Email connot be blank." : "There is no user with that email in the system."
      redirect_to new_forgot_password_path
    end
  end
end
