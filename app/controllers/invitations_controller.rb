class InvitationsController < ApplicationController
  before_filter :user_required!

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(inivitation_params.merge!(inviter_id: current_user.id))

    if @invitation.save
      @invitation.generate_token
      AppMailer.delay.send_invitation_email(@invitation)
      flash[:success] = "You have successfully invited #{@invitation.recipient_name}."
      redirect_to new_invitation_path
    else
      flash[:error] = "Please check your inputs."
      render :new
    end
  end

  protected

  def inivitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end
