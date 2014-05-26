require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      user = Fabricate(:user, token: "ds5g6adsg56adsg456")
      get :show, id: "ds5g6adsg56adsg456"
      expect(response).to render_template :show
    end

    it "sets @token" do
      user = Fabricate(:user, token: "ds5g6adsg56adsg456")
      get :show, id: "ds5g6adsg56adsg456"
      expect(assigns(:token)).to eq("ds5g6adsg56adsg456")
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: "ds5g6adsg56adsg456"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do
      it "redirects to the sign in page" do
        user = Fabricate(:user, token: "ds5g6adsg56adsg456")
        post :create, token: "ds5g6adsg56adsg456", password: "new_password"
        expect(response).to redirect_to sign_in_path
      end

      it "updates the user's password" do
        user = Fabricate(:user, token: "ds5g6adsg56adsg456")
        post :create, token: "ds5g6adsg56adsg456", password: "new_password"
        user.reload
        expect(user.authenticate("new_password")).to be_true
      end

      it "sets the flash success message" do
        user = Fabricate(:user, token: "ds5g6adsg56adsg456")
        post :create, token: "ds5g6adsg56adsg456", password: "new_password"
        expect(flash[:success]).to be_present
      end

      it "truncates the user token" do
        user = Fabricate(:user, token: "ds5g6adsg56adsg456")
        post :create, token: "ds5g6adsg56adsg456", password: "new_password"
        user.reload
        expect(user.token).to be_blank
      end
    end

    context "with invalid token" do
      it "redirects to the expired token path" do
        post :create, token: "ds5g6adsg56adsg456", password: "new_password"
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
