require 'spec_helper'

describe UsersController do
  describe "GET 'new'" do
    before do
      get 'new'
    end

    it "returns http success" do
      expect(response).to be_success
    end

    it "sets the @user" do
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET new_with_invitation_token" do
    let!(:invitation) { Fabricate(:invitation, inviter: Fabricate(:user)) }
    before { invitation.generate_token }

    it "does not require user sign in" do
      clear_current_user
      get :new_with_invitation_token, token: invitation.token
      expect(response).not_to redirect_to(sign_in_path)
    end

    it "renders :new template" do
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired_token page for invalid tokens" do
      get :new_with_invitation_token, token: "asdf"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST 'create'" do

    let(:charge) { double(:charge, successful?: true) }

    context "successful user sign up" do
      let(:user) { Fabricate.build(:user) }

      after(:each) { ActionMailer::Base.deliveries.clear }

      def post_user
        post "create", user: {
          email:     user.email,
          password:  user.password,
          full_name: user.full_name
        }
      end

      it "redirect to sign in page" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post_user
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "failed user sign up" do
      let(:user)   { Fabricate.build(:user) }

      def post_user
        post "create", user: {
          email:     user.email,
          password:  user.password,
          full_name: user.full_name
        }
      end

      it "renders the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "Your card was declined.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)

        post_user
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        result = double(:sign_up_result, successful?: false, error_message: "Your card was declined.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)

        post_user
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "GET 'show'" do
    let!(:user) { Fabricate(:user) }

    it_behaves_like "require_signed_in" do
      let(:action) { get "show", id: user.id }
    end

    before do
      set_current_user(user)
      get "show", id: user.id
    end

    it "sets @user" do
      expect(assigns(:user)).to eq(user)
    end

    it "renders 'show' template" do
      expect(response).to render_template :show
    end
  end
end
