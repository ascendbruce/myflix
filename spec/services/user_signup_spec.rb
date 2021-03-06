require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "with valid personal info and valid card" do
      let(:user)   { Fabricate.build(:user) }
      let(:customer) { double(:customer, successful?: true, customer_token: "qwerasdf") }

      before { StripeWrapper::Customer.should_receive(:create).and_return(customer) }
      after  { ActionMailer::Base.deliveries.clear }

      it "creates a user" do
        UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", nil)
        expect(User.count).to eq 1
      end

      it "stores the customer token from stripe" do
        UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", nil)
        expect(User.first.customer_token).to eq "qwerasdf"
      end

      it "sends out email to the user with valid input" do
        UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", nil)
        expect(ActionMailer::Base.deliveries.last.to).to match_array([user.email])
      end

      it "sends out email containing the user's name with valid input" do
        UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include(user.full_name)
      end

      context "with invitation" do
        let!(:inviter)    { Fabricate.create(:user, email: "alice@example.com") }
        let!(:user)       { Fabricate.build( :user, email: "bob@example.com") } # invitee
        let!(:invitation) { Fabricate.create(:invitation, inviter: inviter, recipient_email: user.email, recipient_name: user.full_name) }

        before { invitation.generate_token }

        it "makes the user follow the inviter" do
          UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", invitation.token)
          newly_signed_up_user = User.where(email: user.email).first
          expect(newly_signed_up_user.follows?(inviter)).to be_true
        end

        it "makes the inviter follow the user" do
          UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", invitation.token)
          newly_signed_up_user = User.where(email: user.email).first
          expect(inviter.follows?(newly_signed_up_user)).to be_true
        end

        it "expires the invitation upon acceptance" do
          UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", invitation.token)
          newly_signed_up_user = User.where(email: user.email).first
          invitation.reload
          expect(invitation.token).to be_nil
        end
      end
    end

    context "with valid personal info and declined card" do
      let(:user)   { Fabricate.build(:user) }
      let(:customer) { double(:customer, successful?: false, error_message: "Your card was declined.") }

      before { StripeWrapper::Customer.should_receive(:create).and_return(customer) }

      it "does not create a new user record" do
        UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", nil)
        expect(User.count).to be_zero
      end
    end

    context "with invalid user info" do
      let(:user)   { User.new(email: "bob@example.com") }
      let(:customer) { double(:customer, successful?: true) }

      it "does not create user" do
        UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", nil)
        expect(User.count).to be_zero
      end

      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
        UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", nil)
      end

      it "does not send out email with invalid inputs" do
        UserSignup.new(user).sign_up("strip-token-no-need-in-doubles", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
