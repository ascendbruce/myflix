class PasswordResetsController < ApplicationController
  def show
    if User.find_by_token(params[:id])
      @token = params[:id]
    else
      redirect_to expired_token_path
    end
  end

  def create
    if user = User.find_by_token(params[:token])
      if user.update_attributes(password: params[:password], token: nil)
        flash[:success] = "Your password has been changed. Please sign in."
        redirect_to sign_in_path
      else
        redirect_to password_reset_path(params[:token])
      end
    else
      redirect_to expired_token_path
    end
  end
end
