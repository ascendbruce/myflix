require 'spec_helper'
require "stripe"

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number    => "4242424242424242",
        :exp_month => 9,
        :exp_year  => Time.now.year+1,
        :cvc       => "314"
      },
    ).id
  end

  let(:declined_token) do
    Stripe::Token.create(
      :card => {
        :number    => "4000000000000002",
        :exp_month => 9,
        :exp_year  => Time.now.year+1,
        :cvc       => "314"
      },
    ).id
  end

  describe StripeWrapper::Customer do
    describe ".create", :vcr do
      let(:alice) { Fabricate(:user, full_name: "Alice Lee") }

      it "creates a customer with valid card" do
        response = StripeWrapper::Customer.create(user: alice, card: valid_token)
        expect(response).to be_successful
      end

      it "does not create a customer with declined card" do
        response = StripeWrapper::Customer.create(user: alice, card: declined_token)
        expect(response).not_to be_successful
      end

      it "returns the error message for declined charge" do
        response = StripeWrapper::Customer.create(user: alice, card: declined_token)
        expect(response.error_message).to eq "Your card was declined."
      end
    end
  end
end
