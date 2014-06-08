require 'spec_helper'

describe ForgotPasswordsController do

  describe "POST 'create'" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ""
        expect(response).to redirect_to(new_forgot_password_path)
      end

      it "shows an error message" do
        post :create, email: ""
        expect(flash[:error]).to eq("Email connot be blank.")
      end
    end

    context "with existing email" do
      after(:each) { ActionMailer::Base.deliveries.clear }

      it "redirect to the forgot password confirmation page" do
        Fabricate(:user, email: "bruce@example.com")
        post :create, email: "bruce@example.com"
        expect(response).to redirect_to confirm_forgot_password_path
      end

      it "sends out an email to the email address" do
        Fabricate(:user, email: "bruce@example.com")
        post :create, email: "bruce@example.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["bruce@example.com"])
      end
    end

    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, email: "non-existing@example.com"
        expect(response).to redirect_to(new_forgot_password_path)
      end

      it "shows and error message" do
        post :create, email: "non-existing@example.com"
        expect(flash[:error]).to eq("There is no user with that email in the system.")
      end
    end

  end

end
