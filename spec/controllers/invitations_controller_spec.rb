require 'spec_helper'

describe InvitationsController do

  describe "GET 'new'" do
    it "sets @invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end

    it_behaves_like "require_signed_in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    after(:each) { ActionMailer::Base.deliveries.clear }
    before { set_current_user }

    it_behaves_like "require_signed_in" do
      let(:action) { post :create }
    end

    context "with valid inputs" do

      it "redirects to the invitation new page" do
        post :create, invitation: { recipient_name: "Marry jan", recipient_email: "jan@example.com", message: "Please join this really cool site!" }
        expect(response).to redirect_to(new_invitation_path)
      end

      it "create an invitation" do
        post :create, invitation: { recipient_name: "Marry jan", recipient_email: "jan@example.com", message: "Please join this really cool site!" }
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        post :create, invitation: { recipient_name: "Marry jan", recipient_email: "jan@example.com", message: "Please join this really cool site!" }
        expect(ActionMailer::Base.deliveries.last.to).to match_array(["jan@example.com"])
      end

      it "sets the flash success message" do
        post :create, invitation: { recipient_name: "Marry jan", recipient_email: "jan@example.com", message: "Please join this really cool site!" }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      it "renders the :new template" do
        post :create, invitation: { recipient_name: "Marry jan", message: "Please join this really cool site!" }
        expect(response).to render_template :new
      end

      it "sets @invitation" do
        post :create, invitation: { recipient_name: "Marry jan", message: "Please join this really cool site!" }
        expect(assigns(:invitation)).to be_new_record
        expect(assigns(:invitation)).to be_instance_of Invitation
      end

      it "does not create an Invitation" do
        post :create, invitation: { recipient_name: "Marry jan", message: "Please join this really cool site!" }
        expect(Invitation.count).to eq(0)
      end

      it "does not send out an email" do
        post :create, invitation: { recipient_name: "Marry jan", message: "Please join this really cool site!" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash error message" do
        post :create, invitation: { recipient_name: "Marry jan", message: "Please join this really cool site!" }
        expect(flash[:error]).to be_present
      end
    end
  end

end
